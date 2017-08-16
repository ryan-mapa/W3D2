require_relative 'question_database.rb'

class QuestionFollow
  attr_accessor :user_id, :question_id

  def self.all
    data = QuestionsDBConnection.instance.execute( "SELECT * FROM question_follows" )
    data.map { |datum| QuestionFollow.new(datum) }
  end

  def self.find_by_id(id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT * FROM question_follows WHERE id = ?
    SQL
    QuestionFollow.new(data[0])
  end

  def self.followers_for_question_id(question_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
      SELECT users.*
      FROM users
      JOIN question_follows ON question_follows.user_id = users.id
      WHERE question_follows.question_id = ?
    SQL
    data.map { |datum| User.new(datum) }
  end

  def self.followed_questions_for_user_id(user_id)
    data =  QuestionsDBConnection.instance.execute(<<-SQL, user_id)
      SELECT questions.*
      FROM questions
      JOIN question_follows ON question_follows.question_id = questions.id
      WHERE questions.user_id = ?
    SQL
    data.map {|datum| Question.new(datum)}
  end

  def self.most_followed_question(n) #n most followed_questions
    data = QuestionsDBConnection.instance.execute(<<-SQL, n)
      SELECT questions.*
      FROM questions
      JOIN question_follows ON questions.id = question_follows.question_id
      GROUP BY question_follows.question_id
      ORDER BY COUNT(question_follows.question_id) DESC
      LIMIT ?
    SQL
    data.map { |datum| Question.new(datum) }
  end

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
end
