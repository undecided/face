require_relative '../lib/structured_api'

ASK = lambda { |q, default = ''|
  puts q, "Default: #{default} >> "
  out = STDIN.gets.strip
  out == '' ? default : out
}

class GhostCms < StructuredApi::Endpoint
  url ASK['What URL is your ghostcms at?', 'https://demo.ghost.io'] + '/ghost/api/v4/content'
  params key: ASK["What is your content API key? (under 'integrations' => 'Custom Integration')",
                  '22444f78447824223cefc48062']
  # might need basicauth, depending on how you are set up
end

class GhostCms::Posts < GhostCms
  path '/posts'
end

## Not possible yet
# class GhostCms::GetPost
#   path '/posts'
#   attribute :id
#
#   def path
#     "/posts/#{id}"
#   end
# end

class GhostCms::Authors < GhostCms
  path '/authors'
end

puts GhostCms::Posts.new.debug!.run!
puts GhostCms::Authors.new.debug!.run!
