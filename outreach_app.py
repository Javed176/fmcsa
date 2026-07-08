import streamlit as st
import re
import time
import random
import smtplib
import os
import pyotp
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import pandas as pd

st.set_page_config(page_title="Multi-Account Outreach Portal", layout="wide")

st.title("运输 | Smart Carrier Outreach Engine (v2.2)")

# --- GOOGLE AUTHENTICATOR SECURITY GATE ---
if "otp_authenticated" not in st.session_state:
    st.session_state.otp_authenticated = False

if not st.session_state.otp_authenticated:
    st.subheader("🔒 Two-Factor Authentication Required")
    st.write("Open your Google Authenticator app and enter the 6-digit verification code below.")
    
    token_input = st.text_input("Verification Code", max_chars=6, placeholder="000000", type="password")
    
    if st.button("Verify & Unlock Engine", width="stretch"):
        totp = pyotp.TOTP('ZHSKYAFEJJIEUFDSYYDAIVZA632CC2QP') 
        
        if totp.verify(token_input.strip()):
            st.session_state.otp_authenticated = True
            st.success("Authentication successful! Welcome back.")
            st.rerun()
        else:
            st.error("Invalid token code or code expired. Please try again.")
            
    st.stop()  

# --- INITIALIZE AUTOMATION STATE ---
if "campaign_running" not in st.session_state:
    st.session_state.campaign_running = False
if "target_idx" not in st.session_state:
    st.session_state.target_idx = 0
if "sender_idx" not in st.session_state:
    st.session_state.sender_idx = 0
if "history_logs" not in st.session_state:
    st.session_state.history_logs = []
if "batch_counter" not in st.session_state:
    st.session_state.batch_counter = 0

# --- SIDEBAR: ANTI-SPAM CONTROLS & BLACKLIST ---
st.sidebar.header("🛡️ Anti-Spam & Delivery Settings")

min_delay, max_delay = st.sidebar.slider("Randomized Delay Range (seconds):", 1, 120, (5, 15))

enable_cooldown = st.sidebar.checkbox("Enable Batch Cooldown Period", value=False)
if enable_cooldown:
    emails_per_batch = st.sidebar.number_input("Send maximum of (emails):", min_value=1, value=10)
    cooldown_seconds = st.sidebar.number_input("Then pause engine for (seconds):", min_value=1, value=30)

st.sidebar.subheader("🚫 Domain & Keyword Blacklist")
blacklist_input = st.sidebar.text_area("Paste domains or keywords to block:", placeholder="badbroker.com\ndontemail.com", height=120)
blacklist = [line.strip().lower() for line in blacklist_input.strip().split("\n") if line.strip()]

# --- STEP 1: SENDER ACCOUNTS CONFIGURATION ---
st.header("🔑 1. Configure Your Sender Accounts")
with st.expander("👉 Click to manage your Sender Emails & App Passwords", expanded=True):
    st.markdown("""
    *Paste your sending accounts below—one per line—separating the email and password with a comma.*
    """)
    
    senders_input = st.text_area("Sender Accounts List:", placeholder="sender1@gmail.com, app_password_here\nsender2@gmail.com, app_password_here", height=120)
    
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
        "Paste any raw text here (Scraped tables, CSV lines, or logs):", 
        placeholder="Drop raw carrier information here...",
        height=180
    )

raw_targets = list(set(re.findall(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}', raw_data_feed)))

extracted_targets = []
for email in raw_targets:
    email_lower = email.lower()
    if "roserocket" in email_lower or "fmcsa" in email_lower:
        continue
    blocked = False
    for item in blacklist:
        if item in email_lower:
            blocked = True
            break
    if not blocked:
        extracted_targets.append(email)

with col_preview:
    st.metric("Extracted Valid Targets", len(extracted_targets))
    st.markdown("**Target List Preview:**")
    if extracted_targets:
        df_preview = pd.DataFrame(extracted_targets, columns=["Target Email"])
        st.dataframe(df_preview, width="stretch", height=120)
    else:
        st.info("Waiting for data...")

# --- STEP 3: EDITABLE TEMPLATE ---
st.header("✉️ 3. Customize Your Personalised Template")
st.caption("Available Placeholders: `{email}` = Full recipient email address | `{domain}` = Email company domain name")

email_subject = st.text_input("Email Subject Line:", placeholder="Available Equipment / Partnership with {domain}")
email_body = st.text_area("Email Body Text:", placeholder="Hello,\n\nWe noticed you are running active equipment...", height=180)

# --- BACKEND SMTP ENGINE ---
def send_outreach_email(sender_meta, target_email, subject, body):
    sender_email = sender_meta["email"]
    sender_password = sender_meta["password"]
    smtp_host = "smtp-mail.outlook.com" if any(x in sender_email.lower() for x in ["outlook", "hotmail"]) else "smtp.gmail.com"
        
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

# --- CONTROLS SYSTEM ---
st.markdown("---")
col_ctrl1, col_ctrl2, col_ctrl3 = st.columns(3)

if col_ctrl1.button("🚀 Start Outreach Blast", width="stretch"):
    if not parsed_senders:
        st.error("Please add at least one valid sender email configuration line.")
    elif not extracted_targets:
        st.error("No target email addresses found to send pitches to.")
    else:
        st.session_state.campaign_running = True
        st.rerun()

if col_ctrl2.button("🛑 STOP Campaign Loop", width="stretch"):
    st.session_state.campaign_running = False
    st.warning("Campaign paused immediately.")

if col_ctrl3.button("🗑️ Reset Campaign Tracker", width="stretch"):
    st.session_state.campaign_running = False
    st.session_state.target_idx = 0
    st.session_state.sender_idx = 0
    st.session_state.batch_counter = 0
    st.session_state.history_logs = []
    st.success("Trackers and metrics reset cleanly.")
    st.rerun()

# --- ACTIVE BLAST LOOP PROCESSING ---
if st.session_state.campaign_running:
    if st.session_state.target_idx >= len(extracted_targets):
        st.session_state.campaign_running = False
        st.success("🎉 Campaign complete! All targets have been messaged.")
        st.rerun()
    else:
        if enable_cooldown and st.session_state.batch_counter >= emails_per_batch:
            st.session_state.batch_counter = 0  
            status_banner = st.empty()
            status_banner.warning(f"💤 Cooldown Triggered! Letting sender accounts rest for {cooldown_seconds} second(s)...")
            time.sleep(cooldown_seconds)
            st.rerun()
            
        current_target = extracted_targets[st.session_state.target_idx]
        current_sender = parsed_senders[st.session_state.sender_idx % len(parsed_senders)]
        
        target_domain = current_target.split("@")[-1] if "@" in current_target else "your company"
        custom_subject = email_subject.replace("{email}", current_target).replace("{domain}", target_domain)
        custom_body = email_body.replace("{email}", current_target).replace("{domain}", target_domain)
        
        status_banner = st.empty()
        status_banner.info(f"Sending: From **{current_sender['email']}** ➡️ To **{current_target}**")
        
        success, message = send_outreach_email(current_sender, current_target, custom_subject, custom_body)
        
        timestamp = time.strftime("%H:%M:%S")
        st.session_state.history_logs.append({
            "Timestamp": timestamp,
            "Sender Account": current_sender["email"],
            "Recipient Target": current_target,
            "Status": "🟢 SENT" if success else "🔴 FAILED",
            "Details": message
            })
            
        st.session_state.target_idx += 1
        st.session_state.sender_idx += 1
        st.session_state.batch_counter += 1
        
        current_delay = random.randint(min_delay, max_delay)
        status_banner.success(f"Waiting {current_delay}s before next cycle...")
        time.sleep(current_delay)
        st.rerun()

# --- LIVE OPERATIONS LOG SHEET & EXPORT ---
st.subheader("📊 Live Campaign Delivery Sheet")
col_m1, col_m2, col_m3 = st.columns(3)
col_m1.metric("Progress", f"{st.session_state.target_idx} / {len(extracted_targets)} Targets")

if parsed_senders:
    col_m2.metric("Next Active Rotation", parsed_senders[st.session_state.sender_idx % len(parsed_senders)]["email"])
if enable_cooldown:
    col_m3.metric("Current Batch Progress", f"{st.session_state.batch_counter} / {emails_per_batch}")

if st.session_state.history_logs:
    df_logs = pd.DataFrame(st.session_state.history_logs)
    st.dataframe(df_logs, width="stretch")
    
    csv_data = df_logs.to_csv(index=False).encode('utf-8')
    st.download_button(
        label="📥 Download Delivery Sheet to Excel/CSV",
        data=csv_data,
        file_name=f"outreach_log_{time.strftime('%Y%m%d_%H%M%S')}.csv",
        mime="text/csv",
        width="stretch"
    )
else:
    st.info("Campaign engine idle. Load raw data text above and click 'Start Outreach Blast'.")