require_relative 'manifest'

class ModelBase
  attr_reader :id

  TABLE_NAMES = {
    'User' => 'users',
    'Question' => 'questions',
    'Reply' => 'replies',
    'QuestionLike' => 'question_likes',
    'QuestionFollow' => 'question_follows'
  }

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{TABLE_NAMES[self.to_s]}
      WHERE
        id = ?
    SQL

    self.new(data.first)
  end

  def self.all
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        #{TABLE_NAMES[self.to_s]}
    SQL

    data.map { |datum| self.new(datum) }
  end

  def save!
    @id ? update! : insert!
  end

  # private
  def non_id_ivars
    ivar_keys = self.instance_variables
    ivar_keys.delete(:@id)

    ivar_keys.map! do |ivar|
      ivar.to_s.sub('@', '').to_sym
    end

    ivar_vals = ivar_keys.map { |key| send(key) }
    ivar_vals.map! do |val|
      val.is_a?(String) ? "'#{val}'" : val
    end

    ivar_keys.zip(ivar_vals).to_h
  end

  def update!
    set_string = non_id_ivars.map do |sym, val|
      "#{sym.to_s} = #{val}"
    end.join(", ")

    where_string = "id = #{id}"

    QuestionsDatabase.instance.execute(<<-SQL)
      UPDATE
        #{TABLE_NAMES[self.class.to_s]}
      SET
        #{set_string}
      WHERE
        #{where_string}
    SQL
  end

  def insert!
    insert_string = "(#{non_id_ivars.keys.join(", ")})"
    values_string = "(#{non_id_ivars.values.join(", ")})"

    QuestionsDatabase.instance.execute(<<-SQL)
      INSERT INTO
        #{TABLE_NAMES[self.class.to_s]} #{insert_string}
      VALUES
        #{values_string}
    SQL

    @id = QuestionsDatabase.instance.last_insert_row_id
  end
end
