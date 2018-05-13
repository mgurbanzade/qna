class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    puts "#{data}"
    stream_from "question-#{data['id']}"
  end
end
