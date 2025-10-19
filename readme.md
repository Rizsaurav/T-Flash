# T-Flash  
**AI-Powered News to Audio**

T-Flash is a voice-first news pipeline that converts real-time headlines into AI-generated audio briefings. It is designed for users who prefer listening over scrolling—commuters, multitaskers, learners, and accessibility-focused users.

It is not another news feed. It is spoken clarity.

---

## Overview

T-Flash delivers category-based news as spoken audio. A user selects a topic, and within seconds, T-Flash fetches headlines, summarizes them using AI, converts them to voice, and makes the audio available for playback.

---

## Features

- Real-time news retrieval using NewsAPI  
- AI-based summarization using Google Gemini  
- Text-to-speech conversion using ElevenLabs  
- Supabase integration for audio storage  
- Supports Web (Next.js) and Mobile (Flutter)  
- n8n-based workflow automation (no traditional backend)

---

## Architecture

User Action → n8n Webhook → NewsAPI → Gemini Summary → ElevenLabs Voice → Supabase Storage → Playback (Web/Mobile)

### Components

| Layer            | Technology     |
|------------------|----------------|
| Frontend (Web)   | Next.js / React |
| Mobile (Optional) | Flutter         |
| Orchestration    | n8n            |
| AI Services      | Gemini, ElevenLabs |
| Data Source      | NewsAPI        |
| Storage          | Supabase       |
| Authentication    | Google OAuth   |

---

## Tech Stack

| Category       | Tools |
|----------------|-------|
| Frontend       | Next.js, Flutter |
| AI / NLP       | Gemini, ElevenLabs |
| Automation     | n8n |
| APIs           | NewsAPI |
| Storage        | Supabase |
| Authentication | Google OAuth |

---

# Getting Started

### 1. Clone the Repository


git clone https://github.com/Rizsaurav/T-Flash.git
cd T-Flash

### 2. Set Up Environment Variables
Create a .env.local file in the root directory and include:

# Supabase  
SUPABASE_URL=your_supabase_url  
SUPABASE_ANON_KEY=your_supabase_key  

# n8n Webhook  
N8N_WEBHOOK_URL=https://your-n8n-instance/webhook/tflash  


### Install Web
cd web
npm install
npm run dev

### Set Up n8n Workflow 
n8n can be installed as:

npm install -g n8n 


### Import Workflow

Open n8n dashboard

Navigate to Import

Upload tflash_workflow.json (included in repository)

Configure Supabase

Create a new Supabase project

Enable Storage

Create a bucket named "tflash-audio"

Add Supabase credentials to .env.local

### Pipeline Overview
[User Selects Topic] -> [n8n Webhook Trigger] ->  [NewsAPI Fetch] -> [Gemini Summary Generation] -> [ElevenLabs TTS Conversion] -> [Supabase Audio Upload] ->  [URL Returned to Frontend]


### Future Enhancements
Personalized voice tones and profiles

Daily scheduled audio briefings

Multi-language news summaries

Offline listening mode



