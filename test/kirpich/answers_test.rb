require 'test_helper'
require 'kirpich/answers'

class Kirpich::AnswersTest < Minitest::Test
  def setup
    @answers = Kirpich::Answers.new
  end

  def test_materialize
    source = 'Lorem Ipsum - это текст-"рыба", часто используемый в печати и вэб-дизайне. Lorem Ipsum является стандартной "рыбой" для текстов на латинице с начала XVI века. В то время некий безымянный печатник создал большую коллекцию размеров и форм шрифтов, используя Lorem Ipsum для распечатки образцов. Lorem Ipsum не только успешно пережил без заметных изменений пять веков, но и перешагнул в электронный дизайн. Его популяризации в новое время послужили публикация листов Letraset с образцами Lorem Ipsum в 60-х годах и, в более недавнее время, программы электронной вёрстки типа Aldus PageMaker, в шаблонах которых используется Lorem Ipsum.'
    text = @answers.materialize(source)
    assert { text.length > source.length }
  end

  def test_developerslife_image
    stub_request(:get, "http://developerslife.ru/random").
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Faraday v0.9.1'}).
      to_return(:status => 200, :body => '', :headers => { location: '//developerslife.ru/1'})

    stub_request(:get, "http://developerslife.ru/1").
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Faraday v0.9.1'}).
      to_return(:status => 200, :body => load_fixture("developerslife.html"), :headers => {})

    assert { @answers.developerslife_image.is_a?(Array) }
  end

  def test_yes_no
    assert { @answers.yes_no_text =~ /(да|нет|возможно)/ }
  end

end
