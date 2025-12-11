# MediNexus

A Flutter healthcare application with Supabase backend.

## Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/AsifJawad15/MediNexus.git
   cd MediNexus
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment variables**
   - Copy `.env.example` to `.env`
   ```bash
   copy .env.example .env
   ```
   - Open `.env` and add your API keys:
     - `SUPABASE_URL`: Your Supabase project URL
     - `SUPABASE_ANON_KEY`: Your Supabase anon/public key
     - Add other API keys as needed (OpenAI, Gemini, etc.)

4. **Create the test table in Supabase** (for testing connection)
   - Go to your Supabase SQL Editor
   - Run the SQL commands in `test_table.sql`

5. **Run the app**
   ```bash
   flutter run
   ```

## Environment Variables

This project uses environment variables to keep sensitive API keys secure. **Never commit the `.env` file to version control.**

Required variables:
- `SUPABASE_URL` - Your Supabase project URL
- `SUPABASE_ANON_KEY` - Your Supabase anonymous key

Optional (add as needed):
- `OPENAI_API_KEY` - For OpenAI integration
- `GEMINI_API_KEY` - For Google Gemini integration
- `ANTHROPIC_API_KEY` - For Anthropic Claude integration
- `GOOGLE_MAPS_API_KEY` - For Google Maps integration

## Project Structure

```
lib/
├── config/
│   └── supabase_config.dart   # Configuration for Supabase
├── pages/
│   └── test_connection_page.dart  # Test page for database connection
└── main.dart                   # App entry point
```

## Testing Database Connection

The app includes a test page to verify your Supabase connection:
- Insert test messages
- View all messages from database
- Delete messages
- Check connection status

## Security Notes

- The `.env` file is excluded from git via `.gitignore`
- Never share your API keys publicly
- Use `.env.example` as a template for other developers
- The Supabase anon key is safe to use in client-side apps (protected by RLS policies)

## Contributing

1. Copy `.env.example` to `.env` and add your credentials
2. Make your changes
3. Test thoroughly
4. Submit a pull request
