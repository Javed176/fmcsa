sudo apt update && sudo apt install git -y
git clone https://github.com/LxaNce-Hacker/Mohini
cd Mohini
bash Mohini.sh
sudo apt update && sudo apt install php php-cli php-curl php-mbstring php-xml -y
1s
ls
php -v
ls
chmod +* *
chmod --help
cd Mohini
bash Mohni.sh
chmod =x *
chmod +x *
./Mohini.sh
chmod +x Mohini.sh
./Mohini.sh
mano 
sudo namo /etc/wsl.conf
sudo nano /etc/wsl.conf
wsl --shutdown
cat /etc/wsl.conf
cd ~
pwd
ls -la
clear
$ git clone https://github.com/LxaNce-Hacker/Mohini
sudo apt update
sudo apt install curl git unzip -y
sudo apt install composer -y
composer install
monolog/monolog
clear
$ git clone https://github.com/LxaNce-Hacker/Mohini
php -S 127.0.0.1:8000
sudo apt install composer -y
composer install
mkdir ~/php-test
cd ~/php-test
composer init
$ git clone https://github.com/LxaNce-Hacker/Mohini
<html lang="en">
<head>
</head>
<body>
</body>
</html>
clear
git clone https://github.com
https://github.com
git clone https://github.com
$ git clone https://github.com/LxaNce-Hacker/Mohini
cd Mohini
bash Mohini.sh
: https://317ef6972250d3f2-223-123-41-65.serveousercontent.com
https://console.serveo.net/settings?n=1&src=ssh_nudge&v=B
clear
1
ls
exit
touch ~/.hushlogin
/Mohini
/Mhini
pip install streamlit pandas requests
sudo apt update && sudo apt install python3-pip python3-venv -y
python3 -m venv transport_env
source transport_env/bin/activate
pip install streamlit pandas requests
streamlit run outreach_app.py
cat << 'EOF' > outreach_app.py
import streamlit as st
import re
import time
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import pandas as pd

st.set_page_config(page_title="Multi-Account Outreach Portal", layout="wide")

st.title("运输 | Smart Carrier Outreach Engine")
st.write("Extract targets from raw logs, rotate through 10 sender accounts, and send fully customizable pitches.")

# --- INITIALIZE AUTOMATION STATE ---
if "campaign_running" not in st.session_state:
    st.session_state.campaign_running = False
if "target_idx" not in st.session_state:
    st.session_state.target_idx = 0
if "sender_idx" not in st.session_state:
    st.session_state.sender_idx = 0
if "history_logs" not in st.session_state:
    st.session_state.history_logs = []

# --- STEP 1: SENDER ACCOUNTS CONFIGURATION ---
st.header("🔑 1. Configure Your 10 Sender Accounts")
with st.expander("👉 Click to manage your 10 Sender Emails & App Passwords", expanded=True):
    st.markdown("""
    *Paste your sending accounts below—one per line—separating the email and password with a comma.* *Example:* `dispatch.tony1@gmail.com, xxxx-xxxx-xxxx-xxxx` *(Use Gmail App Passwords, not regular passwords)*
    """)
    
    default_senders_placeholder = (
        "sender1@gmail.com, app_password_here\n"
        "sender2@gmail.com, app_password_here\n"
        "sender3@gmail.com, app_password_here\n"
        "sender4@gmail.com, app_password_here\n"
        "sender5@gmail.com, app_password_here\n"
        "sender6@gmail.com, app_password_here\n"
        "sender7@gmail.com, app_password_here\n"
        "sender8@gmail.com, app_password_here\n"
        "sender9@gmail.com, app_password_here\n"
        "sender10@gmail.com, app_password_here"
    )
    
    senders_input = st.text_area("Sender Accounts List:", value=default_senders_placeholder, height=220)
    
    # Parse sender accounts list
    parsed_senders = []
    for line in senders_input.strip().split("\n"):
        if "," in line:
            email, pwd = line.split(",", 1)
            parsed_senders.append({"email": email.strip(), "password": pwd.strip()})

# --- STEP 2: RAW DATA & EMAIL EXTRACTION ---
st.header("📋 2. Input Raw Data & Extract Targets")
col_data, col_preview = st.columns([2, 1])

with col_data:
    raw_data_feed = st.text_area(
        "Paste any raw text here (Paste your scraped tables, CSV lines, or raw text logs):", 
        placeholder="Drop raw carrier information here...",
        height=180
    )

# Real-time regex extraction engine
extracted_targets = list(set(re.findall(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}', raw_data_feed)))
# Clean out non-target standard system keywords if copied over accidentally
extracted_targets = [e for e in extracted_targets if "roserocket" not in e.lower() and "fmcsa" not in e.lower()]

with col_preview:
    st.metric("Extracted Valid Targets", len(extracted_targets))
    st.markdown("**Target List Preview:**")
    if extracted_targets:
        df_preview = pd.DataFrame(extracted_targets, columns=["Target Email"])
        st.dataframe(df_preview, use_container_width=True, height=120)
    else:
        st.info("Waiting for data...")

# --- STEP 3: EDITABLE TEMPLATE ---
st.header("✉️ 3. Customize Your Pitch Template")
email_subject = st.text_input("Email Subject Line:", value="Available Equipment / Top-Tier Dispatch Partnership")
email_body = st.text_area(
    "Email Body Text:", 
    value="Hello,\n\nWe noticed you are running active equipment in this lane. AR Transport provides full-service dispatching with consistent premium loads, direct broker lines, and custom maintenance perks after 1 year.\n\nLet us know if you have trucks open this week!\n\nBest regards,\nTony Burns\nManager, AR Transport",
    height=180
)

# --- BACKEND SMTP ENGINE ---
def send_outreach_email(sender_meta, target_email, subject, body):
    """Executes a secure network SMTP connection step."""
    sender_email = sender_meta["email"]
    sender_password = sender_meta["password"]
    
    if "gmail" in sender_email.lower():
        smtp_host = "smtp.gmail.com"
    elif "outlook" in sender_email.lower() or "hotmail" in sender_email.lower():
        smtp_host = "smtp-mail.outlook.com"
    else:
        smtp_host = "smtp.gmail.com"
        
    try:
        msg = MIMEMultipart()
        msg['From'] = sender_email
        msg['To'] = target_email
        msg['Subject'] = subject
        msg.attach(MIMEText(body, 'plain'))
        
        server = smtplib.SMTP(smtp_host, 587, timeout=5)
        server.starttls()
        server.login(sender_email, sender_password)
        server.sendmail(sender_email, target_email, msg.as_string())
        server.quit()
        return True, "Dispatched successfully"
    except Exception as e:
        return False, str(e)

# --- CONTROLS & LOOP SYSTEM ---
st.markdown("---")
col_ctrl1, col_ctrl2, col_ctrl3 = st.columns(3)

if col_ctrl1.button("🚀 Start Outreach Blast", use_container_width=True):
    if not parsed_senders:
        st.error("Please add at least one valid sender email configuration line.")
    elif not extracted_targets:
        st.error("No target email addresses found to send pitches to.")
    else:
        st.session_state.campaign_running = True
        st.rerun()

if col_ctrl2.button("🛑 STOP Campaign Loop", use_container_width=True):
    st.session_state.campaign_running = False
    st.warning("Campaign paused immediately.")

if col_ctrl3.button("🗑️ Reset Campaign Tracker", use_container_width=True):
    st.session_state.campaign_running = False
    st.session_state.target_idx = 0
    st.session_state.sender_idx = 0
    st.session_state.history_logs = []
    st.success("Trackers and progress metrics reset cleanly.")
    st.rerun()

# --- ACTIVE BLAST LOOP PROCESSING ---
if st.session_state.campaign_running:
    if st.session_state.target_idx >= len(extracted_targets):
        st.session_state.campaign_running = False
        st.success("🎉 Campaign complete! All extracted targets have been messaged.")
        st.rerun()
    else:
        current_target = extracted_targets[st.session_state.target_idx]
        current_sender = parsed_senders[st.session_state.sender_idx % len(parsed_senders)]
        
        status_banner = st.empty()
        status_banner.info(f"Sending line package: From **{current_sender['email']}** ➡️ To **{current_target}**")
        
        success, message = send_outreach_email(current_sender, current_target, email_subject, email_body)
        
        timestamp = time.strftime("%H:%M:%S")
        if success:
            st.session_state.history_logs.append({
                "Timestamp": timestamp,
                "Sender Account": current_sender["email"],
                "Recipient Target": current_target,
                "Status": "🟢 SENT",
                "Details": message
            })
        else:
            st.session_state.history_logs.append({
                "Timestamp": timestamp,
                "Sender Account": current_sender["email"],
                "Recipient Target": current_target,
                "Status": "🔴 FAILED",
                "Details": message
            })
            
        st.session_state.target_idx += 1
        st.session_state.sender_idx += 1
        
        time.sleep(1.5)
        st.rerun()

# --- LIVE OPERATIONS LOG SHEET ---
st.subheader("📊 Live Campaign Delivery Sheet")
col_m1, col_m2 = st.columns(2)
col_m1.metric("Progress", f"{st.session_state.target_idx} / {len(extracted_targets)} Targets")
if parsed_senders:
    col_m2.metric("Next Active Sender Rotation", parsed_senders[st.session_state.sender_idx % len(parsed_senders)]["email"])

if st.session_state.history_logs:
    df_logs = pd.DataFrame(st.session_state.history_logs)
    st.dataframe(df_logs, use_container_width=True)
else:
    st.info("Campaign engine idle. Load raw data text above and click 'Start Outreach Blast'.")
EOF

streamlit run outreach_app.py
source transport_env/bin/activate
notepad.exe outreach_app.py
streamlit run outreach_app.py --server.address 0.0.0.0
streamlit run outreach_app.py --server.port 8555 --server.address 0.0.0.0
notepad.exe outreach_app.py
streamlit run outreach_app.py --server.port 8555 --server.address 0.0.0.0
notepad.exe outreach_app.py
streamlit run outreach_app.py --server.port 8555 --server.address 0.0.0.0
source transport_env/bin/activate
streamlit run outreach_app.py --server.port 8555
notepad.exe outreach_app.py
streamlit run outreach_app.py --server.port 8555 --server.address 0.0.0.0
notepad.exe outreach_app.py
streamlit run outreach_app.py --server.port 8555 --server.address 0.0.0.0
notepad.exe outreach_app.py
streamlit run outreach_app.py --server.port 8555 --server.address 0.0.0.0
notepad.exe outreach_app.py
streamlit run outreach_app.py --server.port 8555 --server.address 0.0.0.0
notepad.exe outreach_app.py
streamlit run outreach_app.py --server.port 8555 --server.address 0.0.0.0
source transport_env/bin/activate
streamlit run outreach_app.py --server.port 8555 --server.address 0.0.0.0
source transport_env/bin/activate
streamlit run outreach_app.py --server.port 8555 --server.address 0.0.0.0
pip install requests pandas
pip install requests pandas --break-system-packages
sudo apt update && sudo apt install python3-requests python3-pandas -y
python3 harvester.py
nano harvester.py
python3 harvester.py
nano harvester.py
rmdir name_of_old_folder
ls
rm harvester.py harvester.py.save outreach_app.py
nano harvester.py
python3 harvester.py
rm harvester.py harvester.py.save outreach_app.py
nano harvester.py
python3 harvester.py
pip install beautifulsoup4 --break-system-packages
nano harvester.py
python3 harvester.py
sudo apt update && sudo apt install python3-tk -y
import tkinter as tk
from tkinter import ttk, messagebox, filedialog
import requests
import re
import threading
import time
import urllib.parse
import pandas as pd
# High-fidelity desktop browser layout profile to bypass 403 blocks
BROWSER_HEADERS = {
}
class HarvesterApp:
if __name__ == "__main__":;     root = tk.Tk()
clear
nano app.py
python3 app.py
nano app.py
nano ~/Desktop/CarrierHarvester.desktop
python3 app.py
pip install pandas requests beautifulsoup4 --break-system-packages
python3 app.py
sudo apt update && sudo apt install python3-tk -y
python3 app.py
explorer.exe .
cp leads.csv /mnt/c/Users/Public/Desktop/ 2>/dev/null || cp leads.csv /mnt/c/
python3 app.py
cat << 'EOF' > app.py
import requests
import re
import time
import urllib.parse
import csv

START_MC = 1400000    
TOTAL_COUNT = 20      
OUTPUT_FILE = "/mnt/c/leads.csv"

BROWSER_HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36"
}

def hunt_web_email(company, location):
    if not company or company == "UNKNOWN":
        return "No Public Email"
    query = f'"{company}" {location} carrier contact email'
    url = f"https://html.duckduckgo.com/html/?q={urllib.parse.quote_plus(query)}"
    try:
        time.sleep(0.5)
        res = requests.get(url, headers=BROWSER_HEADERS, timeout=5.0)
        if res.status_code == 200:
            emails = re.findall(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}', res.text)
            clean = [e for e in emails if "duckduckgo" not in e.lower() and "fmcsa" not in e.lower() and not e.endswith(('.png', '.jpg'))]
            if clean:
                return clean[0].lower()
    except: pass
    return "No Public Email"

def fetch_carrier(mc):
    url = f"https://li-public.fmcsa.dot.gov/l_i/pk_authority.v_authority_det?pv_ap_docket={mc}&pv_v_prefix=MC"
    try:
        res = requests.get(url, headers=BROWSER_HEADERS, timeout=5.0)
        if res.status_code == 200 and "Legal Name" in res.text:
            name_m = re.search(r'Legal Name:\s*([^<>\n\r]+)', res.text, re.IGNORECASE)
            name = name_m.group(1).strip().upper() if name_m else "UNKNOWN"
            name = re.sub(r'\s+', ' ', name).replace('&NBSP;', '')
            
            status = "🟢 ACTIVE" if "AUTHORIZED" in res.text.upper() else "🔴 INACTIVE"
            loc_m = re.search(r'Legal Address:[^>]*>([^<>]+),\s*([A-Z]{2})', res.text)
            location = f"{loc_m.group(1).strip()}, {loc_m.group(2).strip()}" if loc_m else "USA"
            
            emails = re.findall(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}', res.text)
            email = emails[0].lower() if (emails and "fmcsa" not in emails[0].lower()) else "No Public Email"
            
            return {"mc": f"MC-{mc}", "name": name, "status": status, "email": email, "location": location}
    except: pass
    return None

print("🚀 Starting Carrier Email Harvester Engine...")
print(f"Creating offline spreadsheet file: '{OUTPUT_FILE}'\n")

with open(OUTPUT_FILE, mode='w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f)
    writer.writerow(["MC Number", "Carrier Business Name", "Operating Status", "Extracted Email", "Base Location"])

    current_mc = START_MC
    for i in range(TOTAL_COUNT):
        print(f"[{i+1}/{TOTAL_COUNT}] Scanning MC-{current_mc}... ", end="", flush=True)
        
        data = fetch_carrier(current_mc)
        if data:
            if data["email"] == "No Public Email":
                data["email"] = hunt_web_email(data["name"], data["location"])
            print(f"✅ Found: {data['name'][:25]} -> {data['email']}")
            writer.writerow([data["mc"], data["name"], data["status"], data["email"], data["location"]])
        else:
            print("❌ Invalid/Dismissed Record")
            writer.writerow([f"MC-{current_mc}", "UNISSUED RECORD", "❌ INACTIVE", "No Public Email", "N/A"])
            
        current_mc += 1
        time.sleep(0.4)

print(f"\n📊 Batch complete! Open your Windows C: Drive to find '{OUTPUT_FILE}'")
EOF

cat << 'EOF' > app.py
import requests
import re
import time
import urllib.parse
import csv

START_MC = 1400000    
TOTAL_COUNT = 20      
OUTPUT_FILE = "/mnt/c/leads.csv"

BROWSER_HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36"
}

def hunt_web_email(company, location):
    if not company or company == "UNKNOWN":
        return "No Public Email"
    query = f'"{company}" {location} carrier contact email'
    url = f"https://html.duckduckgo.com/html/?q={urllib.parse.quote_plus(query)}"
    try:
        time.sleep(0.5)
        res = requests.get(url, headers=BROWSER_HEADERS, timeout=5.0)
        if res.status_code == 200:
            emails = re.findall(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}', res.text)
            clean = [e for e in emails if "duckduckgo" not in e.lower() and "fmcsa" not in e.lower() and not e.endswith(('.png', '.jpg'))]
            if clean:
                return clean[0].lower()
    except: pass
    return "No Public Email"

def fetch_carrier(mc):
    url = f"https://li-public.fmcsa.dot.gov/l_i/pk_authority.v_authority_det?pv_ap_docket={mc}&pv_v_prefix=MC"
    try:
        res = requests.get(url, headers=BROWSER_HEADERS, timeout=5.0)
        if res.status_code == 200 and "Legal Name" in res.text:
            name_m = re.search(r'Legal Name:\s*([^<>\n\r]+)', res.text, re.IGNORECASE)
            name = name_m.group(1).strip().upper() if name_m else "UNKNOWN"
            name = re.sub(r'\s+', ' ', name).replace('&NBSP;', '')
            
            status = "🟢 ACTIVE" if "AUTHORIZED" in res.text.upper() else "🔴 INACTIVE"
            loc_m = re.search(r'Legal Address:[^>]*>([^<>]+),\s*([A-Z]{2})', res.text)
            location = f"{loc_m.group(1).strip()}, {loc_m.group(2).strip()}" if loc_m else "USA"
            
            emails = re.findall(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}', res.text)
            email = emails[0].lower() if (emails and "fmcsa" not in emails[0].lower()) else "No Public Email"
            
            return {"mc": f"MC-{mc}", "name": name, "status": status, "email": email, "location": location}
    except: pass
    return None

print("🚀 Starting Carrier Email Harvester Engine...")
print(f"Creating offline spreadsheet file: '{OUTPUT_FILE}'\n")

with open(OUTPUT_FILE, mode='w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f)
    writer.writerow(["MC Number", "Carrier Business Name", "Operating Status", "Extracted Email", "Base Location"])

    current_mc = START_MC
    for i in range(TOTAL_COUNT):
        print(f"[{i+1}/{TOTAL_COUNT}] Scanning MC-{current_mc}... ", end="", flush=True)
        
        data = fetch_carrier(current_mc)
        if data:
            if data["email"] == "No Public Email":
                data["email"] = hunt_web_email(data["name"], data["location"])
            print(f"✅ Found: {data['name'][:25]} -> {data['email']}")
            writer.writerow([data["mc"], data["name"], data["status"], data["email"], data["location"]])
        else:
            print("❌ Invalid/Dismissed Record")
            writer.writerow([f"MC-{current_mc}", "UNISSUED RECORD", "❌ INACTIVE", "No Public Email", "N/A"])
            
        current_mc += 1
        time.sleep(0.4)

print(f"\n📊 Batch complete! Open your Windows C: Drive to find '{OUTPUT_FILE}'")
EOF

curl -s "https://pastebin.com/raw/LhCHmK41" > app.py 2>/dev/null || cat << 'EOF' > app.py
import requests, re, time, urllib.parse, csv
START_MC, TOTAL_COUNT, OUTPUT_FILE = 1400000, 20, "/mnt/c/leads.csv"
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
print(f"\n📊 Batch complete! Open your Windows C: Drive to find 'leads.csv'")
EOF

curl -s "https://pastebin.com/raw/LhCHmK41" > app.py 2>/dev/null || cat << 'EOF' > app.py
import requests, re, time, urllib.parse, csv
START_MC, TOTAL_COUNT, OUTPUT_FILE = 1400000, 20, "/mnt/c/leads.csv"
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
print(f"\n📊 Batch complete! Open your Windows C: Drive to find 'leads.csv'")
EOF

python3 app.py
curl -s "https://pastebin.com/raw/LhCHmK41" > app.py 2>/dev/null || cat << 'EOF' > app.py
import requests, re, time, urllib.parse, csv
START_MC, TOTAL_COUNT, OUTPUT_FILE = 1400000, 20, "/mnt/c/leads.csv"
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
print(f"\n📊 Batch complete! Open your Windows C: Drive to find 'leads.csv'")
EOF

sed -i 's|"/mnt/c/leads.csv"|"leads.csv"|g' app.py
python3 app.py
explorer.exe leads.csv
MC Number,Carrier Business Name,Operating Status,Extracted Email,Base Location
MC-1400000,UNISSUED RECORD,❌ INACTIVE,No Public Email,N/A
MC-1400001,UNISSUED RECORD,❌ INACTIVE,No Public Email,N/A
MC-1400002,UNISSUED RECORD,❌ INACTIVE,No Public Email,N/A
MC-1400003,UNISSUED RECORD,❌ INACTIVE,No Public Email,N/A
MC-1400004,UNISSUED RECORD,❌ INACTIVE,No Public Email,N/A
MC-1400005,UNISSUED RECORD,❌ INACTIVE,No Public Email,N/A
MC-1400006,UNISSUED RECORD,❌ INACTIVE,No Public Email,N/A
MC-1400007,UNISSUED RECORD,❌ INACTIVE,No Public Email,N/A
MC-1400008,UNISSUED RECORD,❌ INACTIVE,No Public Email,N/A
MC-1400009,UNISSUED RECORD,❌ INACTIVE,No Public Email,N/A
MC-1400010,UNISSUED RECORD,❌ INACTIVE,No Public Email,N/A
MC-1400011,UNISSUED RECORD,❌ INACTIVE,No Public Email,N/A
MC-1400012,UNISSUED RECORD,❌ INACTIVE,No Public Email,N/A
MC-1400013,UNISSUED RECORD,❌ INACTIVE,No Public Email,N/A
MC-1400014,UNISSUED RECORD,❌ INACTIVE,No Public Email,N/A
MC-1400015,UNISSUED RECORD,❌ INACTIVE,No Public Email,N/A
MC-1400016,UNISSUED RECORD,❌ INACTIVE,No Public Email,N/A
MC-1400017,UNISSUED RECORD,❌ INACTIVE,No Public Email,N/A
MC-1400018,UNISSUED RECORD,❌ INACTIVE,No Public Email,N/A
MC-1400019,UNISSUED RECORD,❌ INACTIVE,No Public Email,N/A
python3 app.py
explorer.exe leads.csv
sed -i 's/START_MC = 150000/START_MC = 1066434/g' app.py
python3 app.py
sed -i 's/START_MC = .*/START_MC = 1066434/g' app.py
python3 app.py
explorer.exe leads.csv
cat << 'EOF' > app.py
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
EOF

cat << 'EOF' > app.py
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
EOF

sed -i 's/START_MC, TOTAL_COUNT, OUTPUT_FILE = .*/START_MC, TOTAL_COUNT, OUTPUT_FILE = 1066434, 20, "leads.csv"/g' app.py
curl -s "https://pastebin.com/raw/u96g71C4" > harvester.py
curl -s "https://pastebin.com/raw/u96g71C4" > harvester.p
python3 harvester.py
cat << 'EOF' > harvester.py
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
print(f"\n📊 Batch complete! Type: explorer.exe leads.csv")
EOF

python3 harvester.py
cat << 'EOF' > harvester_app.py
import tkinter as tk
from tkinter import ttk, messagebox
import requests, re, time, urllib.parse, csv, threading

BROWSER_HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
    "Accept-Language": "en-US,en;q=0.5",
    "Connection": "keep-alive",
    "Upgrade-Insecure-Requests": "1"
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
    # Updated URL format to match FMCSA lookup system structure
    url = f"https://li-public.fmcsa.dot.gov/l_i/pk_authority.v_authority_det?pv_ap_docket={mc}&pv_v_prefix=MC"
    try:
        session = requests.Session()
        res = session.get(url, headers=BROWSER_HEADERS, timeout=7.0)
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
                    text_log.insert(tk.END, f"✅ Found: {d['name'][:25]} -> {d['email']}\n\n")
                    w.writerow([d["mc"], d["name"], d["status"], d["email"], d["location"]])
                else:
                    text_log.insert(tk.END, "❌ Security Blocked or Invalid Record\n\n")
                    w.writerow([f"MC-{curr}", "UNISSUED OR BLOCKED", "❌ INACTIVE", "No Public Email", "N/A"])
                
                progress_bar["value"] = i + 1
                curr += 1
                time.sleep(1.0) # Increased delay to prevent aggressive blocking
                
        messagebox.showinfo("Success", "Batch complete! Saved to leads.csv")
        btn_start.config(state=tk.NORMAL)

    threading.Thread(target=run, daemon=True).start()

# Visual Interface Setup
root = tk.Tk()
root.title("Carrier Lead Harvester Engine")
root.geometry("550", "450")

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
btn_start.grid(row=2, column=0, columnspan=2, pady=15, fill=tk.X)

progress_bar = ttk.Progressbar(frame, orient="horizontal", mode="determinate")
progress_bar.grid(row=3, column=0, columnspan=2, pady=5, fill=tk.X)

text_log = tk.Text(frame, height=12, width=60, bg="#1e1e1e", fg="#00ff00", insertbackground="white")
text_log.grid(row=4, column=0, columnspan=2, pady=10)

root.mainloop()
EOF

python3 harvester_app.py
sed -i 's/root.geometry("550", "450")/root.geometry("550x450")/g' harvester_app.py
python3 harvester_app.py
cat << 'EOF' > harvester_app.py
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
EOF

python3 harvester_app.py
