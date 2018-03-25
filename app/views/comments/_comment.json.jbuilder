json.id comment.id
json.content comment.content
json.author comment.user.name
json.created_at comment.created_at
json.time_in_words "#{time_ago_in_words(comment.created_at)} ago"