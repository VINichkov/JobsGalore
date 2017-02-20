class IndexController < ApplicationController
  before_action :category, only: [:main, :by_category]
  def main

  end

  def search

  end

  def category_view
    param = params.permit(:category, :object)
    case param[:object]
      when '1'
        @objs = Industry.find_by_id(param[:category]).company
      when '2'
        @objs = Industry.find_by_id(param[:category]).job
      when '3'
        @objs = Industry.find_by_id(param[:category]).resumes
    end
  end

  def by_category
  end

  private

  def search_params
    params.require(:search).permit(:industry, :object)
  end

  def category
    initHashMemory
    @category=Industry.where('level=?',1)
    if params[:obj].nil?
      params[:obj]='2'
    end
    case params[:obj]
      when '1'
        @objs = {code:1, name:"Companies"}
      when '2'
        @objs = {code:2, name:"Jobs"}
      when '3'
        @objs = {code:2, name:"Resumes"}
    end
  end

  def initHashMemory
    if $memory.hashValue[:industry].nil?
      count = Industry.count
      one_colum_last = count/3-1
      two_colum_last = count/3*2-1
      if count%3==1
        one_colum_last +=1
      elsif count%3==2
        one_colum_last +=1
        two_colum_last +=1
      end
      newHash = {count:count, one_colum_last:one_colum_last,two_colum_last:two_colum_last }
      $memory.hashValue[:industry] = newHash
    end
  end
end
