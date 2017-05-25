select substr(crackit_content, 10, 80) as abc,count(*) as len from nodes where crackit_content is not null group by abc order by len desc;
