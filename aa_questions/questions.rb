require_relative 'question_database'
require_relative 'question_follow'
require_relative 'user'
require_relative 'question_like'
require_relative 'reply'

class Question
  attr_accessor :title, :body, :user_id
  attr_reader :id

  def self.all
    data = QuestionsDBConnection.instance.execute("SELECT * FROM questions")
    data.map {|datum| Question.new(datum)}
  end

  def self.find_by_id(id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT * FROM questions WHERE id = ?
    SQL
    Question.new(data[0])
  end

  def self.find_by_author_id(author_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, author_id)
      SELECT * FROM questions WHERE user_id = ?
    SQL
    data.map {|datum| Question.new(datum)}
  end

  def self.most_followed(n)
    QuestionFollow.most_followed_question(n)
  end

  def self.most_liked(n)
    QuestionLike.most_liked_question(n)
  end

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
  end

  def author
    User.find_by_id(@user_id)
  end

  def replies
    Reply.find_by_question_id(@id)
  end

  def followers
    QuestionFollow.followers_for_question_id(@id)
  end

  def likers
    QuestionLike.likers_for_question_id(@id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(@id)
  end

end
