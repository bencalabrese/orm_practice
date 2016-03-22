require_relative 'manifest'

class QuestionFollow
  attr_accessor :question_id,:user_id

  def self.all
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        question_follows
    SQL

    data.map { |datum| QuestionFollow.new(datum) }
  end

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = ?
    SQL

  data.map { |datum| QuestionFollow.new(datum) }
  end

  def self.followers_for_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.*
      FROM
        question_follows
        JOIN users ON users.id = question_follows.user_id
      WHERE
        question_follows.question_id = ?
    SQL

    data.map { |datum| QuestionFollow.new(datum) }
  end

  def initialize(opts)
    @id = opts['id']
    @question_id = opts['question_id']
    @user_id = opts['user_id']
  end
end
