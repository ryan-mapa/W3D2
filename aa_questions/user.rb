require_relative 'question_database.rb'

class User
  attr_accessor :fname, :lname
  attr_reader :id

  def self.all
    data = QuestionsDBConnection.instance.execute("SELECT * FROM users")
    data.map {|datum| User.new(datum)}
  end

  def self.find_by_id(id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT * FROM users WHERE id = ?
    SQL
    User.new(data[0])
  end

  def self.find_by_name(fname, lname)
    data = QuestionsDBConnection.instance.execute(<<-SQL, fname, lname)
      SELECT *
      FROM users
      WHERE fname LIKE ? AND lname LIKE ?
    SQL
    data.map {|datum| User.new(datum)}
  end


  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def authored_questions
    Question.find_by_author_id(@id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(@id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end

  def average_karma
    data = QuestionsDBConnection.instance.execute(<<-SQL, @id)
      SELECT (CAST(COUNT(question_likes.question_id) AS FLOAT) / COUNT(DISTINCT(questions.id))) AS user_karma
      FROM questions
      LEFT OUTER JOIN question_likes ON question_likes.question_id = questions.id
      WHERE questions.user_id = ?
    SQL
    data.first['user_karma']
  end

  def save
    raise "#{self} already in db" if @id
    QuestionsDBConnection.instance.execute(<<-SQL, @fname, @lname)
      INSERT INTO
        users (fname, lname)
      VALUES
        (?, ?)
    SQL
    @id = QuestionsDBConnection.instance.last_insert_row_id
  end

end
