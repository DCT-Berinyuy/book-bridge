-- Drop the existing function first to fix parameter name conflicts
-- The error "cannot change name of input parameter" happens because 
-- the old function used different parameter names (e.g., query_text)

DROP FUNCTION IF EXISTS search_listings(text, integer, integer);

create or replace function search_listings(
  query text,
  _limit int default 50,
  _offset int default 0
) returns setof listings as $$
begin
  return query
  select *
  from listings
  where
    status = 'available' and (
      title ilike '%' || query || '%' or
      author ilike '%' || query || '%' or
      description ilike '%' || query || '%'
    )
  order by created_at desc
  limit _limit
  offset _offset;
end;
$$ language plpgsql stable;
