import tkinter as tk
from tkinter import ttk, messagebox
import requests, re, time, urllib.parse, csv, threading

BROWSER_HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
    "Accept-Language": "en-US,en;q=0.5",
    "Connection": "keep-alive"
}

def hunt_web_email(c, l):
    if not c or c == "UNKNOWN": return "No Public Email"
    try:
        res = requests.get(f"https://html.duckduckgo.com/html/?q={urllib.parse.quote_plus(f'\"{c}\" {l} carrier contact email')}", headers=BROWSER_HEADERS, timeout=5.0)
        emails = re.findall(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}', res.text)
        clean = [e for e in emails if "duckduckgo" not in e.lower() and "fmcsa" not in e.lower() and not e.endswith(('.png', '.jpg'))]
        if clean: return clean[0].lower()
    except: pass
    return "No Public Email"

def fetch_carrier(mc):
    url = f"https://li-public.fmcsa.dot.gov/l_i/pk_authority.v_authority_det?pv_ap_docket={mc}&pv_v_prefix=MC"
    try:
        res = requests.get(url, headers=BROWSER_HEADERS, timeout=7.0)
        if res.status_code == 200 and ("Legal Name" in res.text or "Name" in res.text):
            n = re.search(r'Legal Name:\s*([^<>\n\r]+)', res.text, re.IGNORECASE)
            name = re.sub(r'\s+', ' ', n.group(1).strip().upper()).replace('&NBSP;', '') if n else "UNKNOWN"
            status = "🟢 ACTIVE" if "AUTHORIZED" in res.text.upper() else "🔴 INACTIVE"
            l = re.search(r'Legal Address:[^>]*>([^<>]+),\s*([A-Z]{2})', res.text)
            loc = f"{l.group(1).strip()}, {l.group(2).strip()}" if l else "USA"
            ems = re.findall(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}', res.text)
            email = ems[0].lower() if (ems and "fmcsa" not in ems[0].lower()) else "No Public Email"
            return {"mc": f"MC-{mc}", "name": name, "status": status, "email": email, "location": loc}
    except: pass
    return None

def start_harvest():
    try:
        start_mc = int(entry_start.get())
        count = int(entry_count.get())
    except ValueError:
        messagebox.showerror("Error", "Please enter valid numbers!")
        return

    btn_start.config(state=tk.DISABLED)
    progress_bar["maximum"] = count
    progress_bar["value"] = 0
    text_log.delete("1.0", tk.END)
    
    def run():
        curr = start_mc
        with open("leads.csv", mode='w', newline='', encoding='utf-8') as f:
            w = csv.writer(f)
            w.writerow(["MC Number", "Carrier Business Name", "Operating Status", "Extracted Email", "Base Location"])
            
            for i in range(count):
                text_log.insert(tk.END, f"Scanning MC-{curr}...\n")
                text_log.see(tk.END)
                
                d = fetch_carrier(curr)
                if d:
                    if d["email"] == "No Public Email": d["email"] = hunt_web_email(d["name"], d["location"])
                    text_log.insert(tk.END, f"✅ Found: {d['name'][:20]} -> {d['email']}\n\n")
                    w.writerow([d["mc"], d["name"], d["status"], d["email"], d["location"]])
                else:
                    text_log.insert(tk.END, "❌ Expired / Blocked Record\n\n")
                    w.writerow([f"MC-{curr}", "UNKNOWN RECORD", "❌ INACTIVE", "No Public Email", "N/A"])
                
                progress_bar["value"] = i + 1
                curr += 1
                time.sleep(1.0)
                
        messagebox.showinfo("Success", "Batch complete! Saved to leads.csv")
        btn_start.config(state=tk.NORMAL)

    threading.Thread(target=run, daemon=True).start()

root = tk.Tk()
root.title("Carrier Lead Harvester Engine")
root.geometry("550x450")

frame = ttk.Frame(root, padding="10")
frame.pack(fill=tk.BOTH, expand=True)

ttk.Label(frame, text="Starting MC Number:").grid(row=0, column=0, sticky=tk.W, pady=5)
entry_start = ttk.Entry(frame, width=20)
entry_start.insert(0, "1066434")
entry_start.grid(row=0, column=1, pady=5)

ttk.Label(frame, text="Records to Scan:").grid(row=1, column=0, sticky=tk.W, pady=5)
entry_count = ttk.Entry(frame, width=20)
entry_count.insert(0, "20")
entry_count.grid(row=1, column=1, pady=5)

btn_start = ttk.Button(frame, text="🚀 Launch Harvester Engine", command=start_harvest)
btn_start.grid(row=2, column=0, columnspan=2, pady=15, sticky="ew")

progress_bar = ttk.Progressbar(frame, orient="horizontal", mode="determinate")
progress_bar.grid(row=3, column=0, columnspan=2, pady=5, sticky="ew")

text_log = tk.Text(frame, height=12, width=60, bg="#1e1e1e", fg="#00ff00", insertbackground="white")
text_log.grid(row=4, column=0, columnspan=2, pady=10)

root.mainloop()
