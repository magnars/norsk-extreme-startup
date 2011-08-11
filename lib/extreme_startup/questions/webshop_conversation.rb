module ExtremeStartup::Questions
  include ExtremeStartup

  class WebshopConversation < Conversation
    class WebshopState
	end
	class RequestingProductList < WebshopState
	end
    class RequestingPrice < WebshopState
	end
	class Shopping < WebshopState
	end
	class DoneShopping < WebshopState
	end
	class Done < WebshopState
	end
	
    def initialize(product_list = nil, shopping_cart = {})
	  @shoppedProducts = 0
      @product_list = product_list
      @shopping_cart = shopping_cart
	  @productPrices = {}
	  if (@product_list == nil || @product_list.empty?) 
		@state = RequestingProductList
	  elsif (@product_list.has_value?(nil))
	    @state = RequestingPrice
	  else
        @state = Shopping	  
      end
	  
    end
     
    def dead?
      not answered_correctly? or @state == Done
    end
	
	def productListSize
	  if (@product_list == nil)
		return 0
	  end
	  return @product_list.size
	end
    
    def question
      @queried_product = @purchased_product = nil	  
      if @state == RequestingProductList
	    if (@product_list == nil)
			return "what products do you have for sale (comma separated)"
		else
			@state = RequestingPrice
		end
	  end 
	  
	  if @state == RequestingPrice
	      if ready_to_shop?
		     @queried_product = @product_list.keys.pick_one
			return "how many dollars does one #{@queried_product} cost"
	      end
		  @state = Shopping		  
	  end	  
	  
	  if @state == Shopping
	    if (@shopping_cart.size == 4 || @shopping_cart.size == @product_list.size)
		    @state = DoneShopping
		else
		    @purchased_product = @product_list.keys.pick_one
			@purchased_amount = rand(20)
			return "please put #{@purchased_amount} #{@purchased_product} in my shopping cart"
		end		
      end
	  
	  if @state == DoneShopping	    
	    @state = Done
	    return "what is my order total"
	  end 
	  
	  return "Why am I here ?"
	  
    end
    
    def still_shopping?
      for product in @product_list.keys
        return product if not @shopping_cart[product]
      end
      return false
    end
    
    def ready_to_shop?
      @product_list.has_value?(nil)
    end
    
    def add_answer(answer)
      if @state == RequestingProductList
        @product_list = {} 
        answer.split(",").each { |p| @product_list[p.strip] = nil }
      elsif @state == RequestingPrice
        @price = Float(answer) rescue nil
        @product_list[@queried_product] = @price
      elsif @state == Shopping
        @shopping_cart[@purchased_product] = @purchased_amount
      end
      @answer = answer
    end
    
    def price_for(product)
      @product_list[product]
    end
    
    def order_total
      total = 0
      for product in @product_list.keys
        total += @shopping_cart[product] * price_for(product)
      end      
      total
    end
    
    def answered_correctly?
	  if @state == RequestingProductList
	    return @product_list.size > 1
      elsif @state == RequestingPrice
	    return @price
      elsif @state == Done
        return (Float(@answer.strip) rescue nil) == order_total
      end
      true
    end
    
    def shopping_cart_count_for(product)
      @shopping_cart[product]
    end

    def points
      @answer.split(",").length
    end
	
	def penalty
	  -100
	end
  end
  
  class WebshopQuestion < ConversationalQuestion
    def create_session
      WebshopConversation.new
    end    

    def spawn?(sessions, spawn_rate)
      return true if sessions.empty?
      return false if sessions.length > 3
      (rand(100) < spawn_rate)
    end
  end
end
