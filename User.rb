require_relative 'manifest'

class User
  attr_accessor :fname, :lname

  def self.all
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        users
    SQL

    data.map { |datum| User.new(datum) }
  end

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL

    User.new(data.first)
  end

  def self.find_by_name(fname, lname)
    data = QuestionsDatabase.instance.execute(<<-SQL, fname: fname, lname: lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = :fname AND lname = :lname
    SQL

    User.new(data.first)
  end

  def initialize(opts)
    @id = opts['id']
    @fname = opts['fname']
    @lname = opts['lname']
  end

  def authored_questions
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id: @id)
      SELECT
        *
      FROM
        questions
      WHERE
        user_id = :user_id
    SQL

    data.map { |datum| Question.new(datum) }
  end

  def authored_replies
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id: @id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = :user_id
    SQL

    data.map { |datum| Reply.new(datum) }
  end
end
