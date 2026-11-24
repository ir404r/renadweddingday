-- جدول رسائل الضيوف لدعوة رِناد وعلي
-- قبل التشغيل: غيّري your@email.com في السطرين اللي تحت إلى إيميلك

create table if not exists public.messages (
  id bigint generated always as identity primary key,
  created_at timestamptz not null default now(),
  name text not null check (char_length(name) between 1 and 80),
  message text not null check (char_length(message) between 1 and 600)
);

alter table public.messages enable row level security;

-- أي ضيف يقدر يرسل رسالة، بس ما يقدر يقرأ رسائل غيره
create policy "guests_can_send" on public.messages
  for insert to anon, authenticated with check (true);

-- القراءة والحذف لك أنتِ فقط
create policy "owner_can_read" on public.messages
  for select to authenticated using ((auth.jwt() ->> 'email') = 'your@email.com');

create policy "owner_can_delete" on public.messages
  for delete to authenticated using ((auth.jwt() ->> 'email') = 'your@email.com');
