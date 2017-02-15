data{
	int N; 			//length of dataset
	vector[N] y;	//response observations
	vector[N] x;	//input observations
}
parameters{
	real beta0;
	real beta1;
	real<lower=0> sigma;
}
model{
	beta0 ~ uniform(-1,1);				//prior on beta0
	beta1 ~ uniform(-1,1);				//prior on beta1
	y ~ normal(beta0 + beta1*x, sigma);	//likelihood model
}
generated quantities{
	vector[N] y_pred;
//	vector[N] log_lik;

	for (i in 1:N)
		y_pred[i] = beta0 + beta1*x[i];
	// Marginal log likelihood
	//for (i in 1:N)
	//	log_lik[i] = normal_lpdf(y[i] | beta0 + beta1*x[i], sigma);
}

