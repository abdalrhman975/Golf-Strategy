-- ============================================
-- جدول حفظ مسارات "لعبة الغولف" — نسخة تسجيل الدخول بالرابط السحري
-- نفّذ هذا الملف كاملاً داخل Supabase → SQL Editor → Run
-- ============================================

create table if not exists golf_sessions (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- تفعيل حماية مستوى الصفوف (مطلوب من Supabase)
alter table golf_sessions enable row level security;

-- كل مستخدم يرى ويعدّل جلسته الخاصة فقط (auth.uid() = هوية المستخدم المسجّل دخوله حاليًا)
create policy "users can read their own session"
  on golf_sessions for select
  using (auth.uid() = user_id);

create policy "users can insert their own session"
  on golf_sessions for insert
  with check (auth.uid() = user_id);

create policy "users can update their own session"
  on golf_sessions for update
  using (auth.uid() = user_id);

create index if not exists idx_golf_sessions_user on golf_sessions (user_id);
