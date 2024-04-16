function isPrime num
	return no if num <= 1
	for i from 2 to Math.sqrt num
		if num % i == 0
			return no
	yes

# Using the function to check for prime numbers
console.log isPrime "Is 17 a prime number?", 17 # true


