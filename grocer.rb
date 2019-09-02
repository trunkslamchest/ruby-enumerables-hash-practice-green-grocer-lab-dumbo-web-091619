def consolidate_cart(cart)
	key_hash = Hash.new(0)

		con_cart = cart.reduce({}) { |new_hash, sub_hash|
			sub_hash.each { |key, sub_keys|
				key_hash[key] += 1
				sub_keys[:count] = key_hash.fetch(key)
				new_hash[key] = sub_keys
			}
		new_hash
		}

	return con_cart
end

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

def apply_coupons(items, coupons)

	coupon_add = coupons.reduce(items) { |memo, hash|

		if memo.keys.include?(hash[:item])
		  
			coupon_keys = hash.shift
			memo_keys = memo[coupon_keys[1]]

			memo["#{coupon_keys[1]} W/COUPON"] = hash

			hash[:price] = hash.delete :cost
			hash[:clearance] = memo_keys[:clearance]
			hash[:count] = hash.delete :num
		  hash[:price] = hash[:price] / hash[:count]

				if memo_keys[:count] >= hash[:count]
					memo_keys[:count] = memo_keys[:count] - hash[:count]
				end

				if coupons.length >= 2 && memo_keys[:count] >= hash[:count]
					memo_keys[:count] = memo_keys[:count] - hash[:count]
					hash[:count] += hash[:count]
				end
		end
	memo
	}

return coupon_add
end

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

def apply_clearance(cart)

	discount_prices = cart.reduce({}) { |memo, food_hash|

  	food_keys = food_hash[0]
  	food_values = food_hash[1]

  		if food_values[:clearance]
  			food_values[:price] = food_values[:price] - (food_values[:price] * 0.2).round(2)
  		end

	  memo[food_keys] = food_values

	memo
	}

return discount_prices
end

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

def checkout(cart, coupons)

	total = 0
	reduce_cart = consolidate_cart(cart)

	do_coupons = apply_coupons(reduce_cart, coupons).reduce({})  { |memo, food_hash|

		food_keys = food_hash[0]
		food_values = food_hash[1]

			if food_values[:count] >= 1
				food_values[:price] = food_values[:price] * food_values[:count]
			end

		memo[food_keys] = food_values

	memo
	}

	do_sale = apply_clearance(do_coupons).reduce({}) { |memo, food_hash|

		food_keys = food_hash[0]
		food_values = food_hash[1]

			if food_values[:count] > 0
				memo[food_keys] = food_values
			end

	memo
	}

	total = do_sale.reduce(0) { |sum, food_hash|

		food_values = food_hash[1]

		sum += food_values[:price]

			if sum > 100.0
				sum = sum - (sum * 0.1).round(2)
			end

	sum
	}

return total
end