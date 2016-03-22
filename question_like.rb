require_relative 'orm'

require_relative 'orm'

class QuestionLike
  attr_accessor :user_id,:question_id

  def self.all
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        question_likes
    SQL

    data.map { |datum| QuestionLike.new(datum) }
  end

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        id = ?
    SQL

    QuestionLike.new(data.first)
  end

  def initialize(opts)
    @id = opts['id']
    @user_id = opts['user_id']
    @question_id = opts['question_id']
  end
end
