require_relative 'question_database.rb'

class QuestionLike
  attr_accessor :question_id, :user_id

  def self.all
    data = QuestionsDBConnection.instance.execute("SELECT * FROM question_likes")
    data.map {|datum| QuestionLike.new(datum)}
  end

  def self.find_by_id(id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT * FROM question_likes WHERE id = ?
    SQL
    QuestionLike.new(data[0])
  end

  def self.likers_for_question_id(question_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
      SELECT users.*
      FROM users
      JOIN question_likes ON question_likes.user_id = users.id
      WHERE question_likes.question_id = ?
    SQL
    data.map { |datum| User.new(datum) }
  end

  def self.num_likes_for_question_id(question_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
      SELECT COUNT(*) AS num_likes
      FROM question_likes
      WHERE question_id = ?
    SQL
    data.first['num_likes']
  end

  def self.liked_questions_for_user_id(user_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
      SELECT questions.*
      FROM questions
      JOIN question_likes ON question_likes.question_id = questions.id
      WHERE question_likes.user_id = ?
    SQL
    data.map {|datum| Question.new(datum)}
  end

  def self.most_liked_question(n)
    data = QuestionsDBConnection.instance.execute(<<-SQL, n)
      SELECT questions.*
      FROM questions
      JOIN question_likes ON question_likes.question_id = questions.id
      GROUP BY question_likes.question_id
      ORDER BY COUNT(question_likes.question_id) DESC
      LIMIT ?
    SQL
    data.map {|datum| Question.new(datum)}
  end

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end
end
