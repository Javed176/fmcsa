import requests, re, time, urllib.parse, csv
START_MC, TOTAL_COUNT, OUTPUT_FILE = 1066434, 20, "leads.csv"
BROWSER_HEADERS = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"}
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
    try:
        res = requests.get(f"https://li-public.fmcsa.dot.gov/l_i/pk_authority.v_authority_det?pv_ap_docket={mc}&pv_v_prefix=MC", headers=BROWSER_HEADERS, timeout=5.0)
        if res.status_code == 200 and "Legal Name" in res.text:
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
print("🚀 Starting Carrier Email Harvester Engine...\n")
with open(OUTPUT_FILE, mode='w', newline='', encoding='utf-8') as f:
    w = csv.writer(f)
    w.writerow(["MC Number", "Carrier Business Name", "Operating Status", "Extracted Email", "Base Location"])
    curr = START_MC
    for i in range(TOTAL_COUNT):
        print(f"[{i+1}/{TOTAL_COUNT}] Scanning MC-{curr}... ", end="", flush=True)
        d = fetch_carrier(curr)
        if d:
            if d["email"] == "No Public Email": d["email"] = hunt_web_email(d["name"], d["location"])
            print(f"✅ Found: {d['name'][:20]} -> {d['email']}")
            w.writerow([d["mc"], d["name"], d["status"], d["email"], d["location"]])
        else:
            print("❌ Invalid/Dismissed")
            w.writerow([f"MC-{curr}", "UNISSUED RECORD", "❌ INACTIVE", "No Public Email", "N/A"])
        curr += 1
        time.sleep(0.4)
print(f"\n📊 Batch complete! Open your Windows file to find 'leads.csv'")
