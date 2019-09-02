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



def apply_clearance(cart)
			sale_items = cart.reduce({}) { |new_hash, sub_hash|
				if sub_hash[1][:clearance]
					sub_hash[1][:price] = sub_hash[1][:price] - (sub_hash[1][:price] * 0.2).round(2)
				end
			 new_hash[sub_hash[0]] = sub_hash[1]
		new_hash
		}

return sale_items
end

# def checkout(cart, coupons)
#   # code here
# end
