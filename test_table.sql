-- Create a test table in Supabase
-- Run this in the Supabase SQL Editor: https://hizvjwpdjkaewhnytmez.supabase.co/project/hizvjwpdjkaewhnytmez/sql

CREATE TABLE IF NOT EXISTS test_connection (
  id SERIAL PRIMARY KEY,
  message TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- Enable Row Level Security
ALTER TABLE test_connection ENABLE ROW LEVEL SECURITY;

-- Create a policy that allows all operations (for testing purposes only)
CREATE POLICY "Allow all operations on test_connection" ON test_connection
  FOR ALL
  USING (true)
  WITH CHECK (true);
