-- Supabase > SQL Editor 에 이 내용을 통째로 붙여넣고 Run 을 누르세요. (한 번만)

create table if not exists public.docs (
  user_id    uuid        not null references auth.users(id) on delete cascade,
  id         text        not null,
  data       jsonb       not null,
  updated_at timestamptz not null default now(),
  primary key (user_id, id)
);

alter table public.docs enable row level security;

-- 로그인한 본인의 데이터만 읽고 쓸 수 있게 막는 규칙
create policy "own rows select" on public.docs for select using (auth.uid() = user_id);
create policy "own rows insert" on public.docs for insert with check (auth.uid() = user_id);
create policy "own rows update" on public.docs for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "own rows delete" on public.docs for delete using (auth.uid() = user_id);
