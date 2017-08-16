require_relative 'question_database.rb'

class Reply
  attr_accessor :title, :body, :question_id, :user_id, :reply_id
  attr_reader :id

  def self.all
    data = QuestionsDBConnection.instance.execute("SELECT * FROM replies")
    data.map {|datum| Reply.new(datum)}
  end

  def self.find_by_id(id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT * FROM replies WHERE id = ?
    SQL
    Reply.new(data[0])
  end

  def self.find_by_question_id(id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT * FROM replies WHERE question_id = ?
    SQL
    data.map {|datum| Reply.new(datum)}
  end

  def self.find_by_user_id(id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT * FROM replies WHERE user_id = ?
    SQL
    data.map {|datum| Reply.new(datum)}
  end

  def self.find_by_reply_id(id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT * FROM replies WHERE reply_id = ?
    SQL
    data.map {|datum| Reply.new(datum)}
  end

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @question_id = options['question_id']
    @user_id = options['user_id']
    @reply_id = options['reply_id']
  end

  def author
    User.find_by_id(@user_id)
  end

  def question
    Question.find_by_id(@question_id)
  end

  def parent_reply
    return nil unless reply_id
    Reply.find_by_id(@reply_id)
  end

  def child_replies
    data = QuestionsDBConnection.instance.execute(<<-SQL, @id)
      SELECT * FROM replies WHERE reply_id = ?
    SQL
    data.map {|datum| Reply.new(datum)}
  end

end
