
# 📹 Zoom Integration with Salesforce (Apex + Named Credential)

This project demonstrates how to integrate **Zoom REST APIs** with Salesforce using:

- Apex (Queueable Callouts)
- Named Credentials
- Auth Provider (OAuth 2.0)
- Custom Object (`Zoom_Meeting__c`)
- Lightning App
- Apex Trigger Automation

It allows users to **create, update, and cancel Zoom meetings directly from Salesforce.**

---

## 🏗️ Architecture Overview

```text
User (Lightning App)
        ↓
Zoom_Meeting__c Record
        ↓
Apex Trigger
        ↓
Queueable Apex (Callout)
        ↓
Named Credential (OAuth)
        ↓
Zoom REST API
```

---

## 🚀 Features

- ✅ Create Zoom meeting from Salesforce  
- ✅ Cancel Zoom meeting  
- ✅ Update Zoom meeting  
- ✅ Automatic status update (Scheduled / Cancelled / Failed)  
- ✅ OAuth-based secure authentication  
- ✅ Async callouts using Queueable Apex  
- ✅ Lightning App for user interaction  

---

## 📂 Project Components

### 🔹 1. Custom Object

**Zoom_Meeting__c**

Fields:

- `Topic__c`  
- `Start_Time__c`  
- `Duration__c`  
- `Time_Zone__c`  
- `Zoom_Meeting_Id__c`  
- `Join_URL__c`  
- `Status__c`  

---

### 🔹 2. Apex Classes

#### ZoomIntegration

Handles:

- Create meeting (POST)  
- Update meeting (PATCH)  
- Cancel meeting (DELETE)  
- Response handling  

#### Queueable Apex Class

Executes HTTP callouts asynchronously.

---

### 🔹 3. Apex Trigger

Trigger runs on:

- **After Insert** → Create Zoom meeting  
- **After Update** → Update Zoom meeting  
- **Before Delete** → Cancel Zoom meeting  

---

### 🔹 4. Authentication Setup

Uses OAuth 2.0 flow:

1. Created Zoom Developer Account  
2. Created Zoom Web App  
3. Configured application scopes  
4. Retrieved Client ID & Client Secret  
5. Configured Salesforce:  
   - Auth Provider  
   - Named Credential  

---

## 🔐 Authentication Flow

Salesforce → Named Credential → Auth Provider → Zoom OAuth → Access Token → API Call

No credentials stored in Apex.

---

## ⚙️ Setup Guide

### 1️⃣ Zoom Setup

1. Go to Zoom Developer Portal  
2. Create Web App  
3. Add Redirect URL from Salesforce Auth Provider  
4. Add required scopes:  
   - `meeting:write`  
   - `meeting:read`  
5. Copy Client ID & Client Secret  

---

### 2️⃣ Salesforce Setup

#### Create Auth Provider

- Provider Type: OpenID Connect  
- Consumer Key → Zoom Client ID  
- Consumer Secret → Zoom Client Secret  

#### Create Named Credential

- URL: `https://api.zoom.us`  
- Identity Type: Named Principal  
- Authentication: OAuth  
- Select Auth Provider  

---

### 3️⃣ Deploy Apex

Deploy:

- ZoomIntegration class  
- Queueable class  
- Trigger  
- Custom object  

---

## 🧪 How It Works

### Creating a Meeting

1. User creates `Zoom_Meeting__c` record  
2. Trigger fires  
3. Queueable Apex executes callout  
4. Zoom meeting is created  
5. Salesforce record updated with:  
   - Zoom Meeting ID  
   - Join URL  
   - Status = Scheduled  

### Updating a Meeting

1. Record edited  
2. Trigger fires  
3. PATCH request sent to Zoom  
4. Status updated  

### Cancelling a Meeting

1. Record deleted (or marked cancelled)  
2. DELETE request sent to Zoom  
3. Status updated to Cancelled  

---

## 📌 Status Logic

| Zoom Response | Salesforce Status |
|---------------|-----------------|
| 201           | Scheduled       |
| 204           | Cancelled / Updated |
| Other         | Failed          |

---

## 🧠 Technical Concepts Used

- Queueable Apex  
- HTTP Callouts  
- JSON Serialization  
- OAuth 2.0  
- Named Credentials  
- Apex Triggers  
- Lightning App Builder  

---

## 📸 UI Overview

Lightning App: **Zoom Integration**

- Record List Page  
- Create / Edit / Delete Meetings  
- Auto Zoom Sync  

---

## 📦 Deployment to Git

Retrieve metadata:

\`\`\`bash
sf project retrieve start --metadata ApexClass,ApexTrigger,CustomObject,Flow --target-org myOrg
\`\`\`

Push to GitHub:

\`\`\`bash
git add .
git commit -m "Zoom integration initial version"
git push
\`\`\`

---

## 🔒 Security Best Practices

- No credentials hardcoded  
- OAuth token managed by Named Credential  
- Callouts executed asynchronously  
- Status handling for failures  

---

## 🎯 Future Improvements

- Add error logging object  
- Add retry mechanism  
- Add UI button for manual sync  
- Add batch meeting creation  
- Add test coverage for callouts  

---

## 👨‍💻 Author

Salesforce Developer  
Zoom + Apex Integration Project
