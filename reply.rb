require_relative 'orm'

class Reply
  attr_accessor :question_id,:user_id,:body

  def self.all
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        replies
    SQL

    data.map { |datum| Reply.new(datum) }
  end

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL

    Reply.new(data.first)
  end

  def initialize(opts)
    @id = opts['id']
    @question_id = opts['question_id']
    @user_id = opts['user_id']
    @body = opts['body']
  end
end
