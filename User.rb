require_relative 'manifest'

class User < ModelBase
  attr_accessor :fname, :lname

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
    Question.find_by_author_id(@id)
  end

  def authored_replies
     Reply.find_by_user_id(@id)
  end

  def followed_questions
    QuestionFollow.questions_for_user_id(@id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end

  def average_karma
    data = QuestionsDatabase.instance.execute(<<-SQL, id: @id)
      SELECT
        (CAST(COUNT(question_likes.id) AS FLOAT)
        / COUNT(DISTINCT(questions.id))) AS avg_likes
      FROM
        questions
        LEFT OUTER JOIN question_likes
          ON question_likes.question_id = questions.id
      WHERE
        questions.user_id = :id
    SQL

    data.first['avg_likes']
  end
end
