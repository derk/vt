#encoding:utf-8
class HomeController < ApplicationController
	# layout 'magazine'
	layout 'standard'
	def index
		# @title = "摩登客—全球设计品牌精品第e站,都市时尚女性个性首选"
		@home = Ecstore::Home.last
		if signed_in?
		   redirect_to params[:return_url] if params[:return_url].present?
		end
	end

	def blank
		@return_url = params[:return_url]
		render :layout=>nil
	end

	def topmenu
		render :layout=>nil
	end
	
	def subscription_success
		@title = "摩登客—全球设计品牌精品第e站,都市时尚女性个性首选"
	end

end
