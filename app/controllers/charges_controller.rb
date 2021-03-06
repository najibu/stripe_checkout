class ChargesController < ApplicationController
	def create
		@book = Book.find(params[:book_id])

		# Amount is in cents
		@amount = @book.price 
		@amount = @amount.to_i 

		customer = Stripe::Customer.create(
      :email => params[:stripeEmail], 
      :source => params[:stripeToken]
		)

		charge = Stripe::Charge.create(
      :customer => customer.id, 
      :amount => @amount, 
      :description => @book.title, 
      :currency => 'usd'
		)

	rescue Stripe::CardError => e 
		flash[:error] = e.message 
		redirect_to new_charge_path
	end
end
