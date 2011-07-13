class Corpus
  attr_reader :terms, :document_count

  def initialize
    @terms = {}
    @document_count = 0
  end

  def <<(document)
    @document_count += 1
    document.terms.uniq.each do |term|
      if @terms[term]
        @terms[term][:count] += 1
      else
        @terms[term] = {:count => 1}
      end
    end
  end

  def inverse_document_frequency(term)
    Math.log(@document_count.to_f / (1 + document_count_for_term(term)))
  end

  def document_count_for_term(term)
    if @terms[term]
      @terms[term][:count]
    else
      0
    end
  end

  def vector_space(document)
    vector_space = []
    vector_space_index = 0
    @terms.each_pair do |term, count|
      if document.has_term?(term)
        vector_space[vector_space_index] = document.term_frequency[term] * self.inverse_document_frequency(term)
      else
        vector_space[vector_space_index] = 0
      end
      vector_space_index += 1
    end
    vector_space
  end

  def terms_list
    terms_list = []
    @terms.each_pair do |term, count|
      terms_list << term
    end
    terms_list
  end

  def similarity(document1, document2)
    vector_space(document1).similarity(vector_space(document2))
  end
end