require_relative 'manifest'

class QuestionFollow < ModelBase
  attr_accessor :question_id,:user_id

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

    data.map { |datum| User.new(datum) }
  end

  def self.questions_for_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.*
      FROM
        question_follows
        JOIN questions ON questions.id = question_follows.question_id
      WHERE
        question_follows.user_id = ?
    SQL

    data.map { |datum| Question.new(datum) }
  end

  def self.most_followed_questions(n)
    data = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        questions.*
      FROM
        questions
        JOIN question_follows ON questions.id = question_follows.question_id
        JOIN users ON users.id = question_follows.user_id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(*) DESC
      LIMIT
        ?
    SQL

    data.map { |datum| Question.new(datum) }
  end

  def initialize(opts)
    @id = opts['id']
    @question_id = opts['question_id']
    @user_id = opts['user_id']
  end
end
