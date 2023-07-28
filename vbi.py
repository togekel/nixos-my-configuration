import scipy.stats as stats
import numpy as np
def VI(data_set,prior_mean,prior_cov,maxmum=100,tol=1e-4):
	N=len(data_set)
	D=len(prior_mean)
	mean=np.mean(data_set,axis=0)
	cov=np.cov(data_set,rowvar=False)
	n=0
	while n<maxmum:
		post_precision=N*np.linalg.inv(cov)
		prior_precision=np.linalg.inv(prior_cov)
		#创建先验分布和后验分布的概率分布
		prior_dist=stats.multivariate_normal(prior_mean,prior_cov)
		post_dist=stats.multivariate_normal(mean,cov)
		#KL 散度
		kl_divergence=stats.entropy(post_dist.pdf,prior_dist.pdf)
		if kl_divergence<tol:
			break
		#精度和协方差的期望
		expected_precision=prior_precision + post_precision
		expected_cov=np.linalg.inv(expected_precision)
		#计算均值的期望
		expeted_mean=expected_cov @ (prior_precision @ prior_mean + post_precision @ mean)
		#更新均值和协方差
		mean=expected_mean
		cov=expected_cov
		n+=1
		print(n)
		return mean , cov

np.random.seed(0)
data_set=np.random.multivariate_normal([1,2],[[1,0.5],[0.5,2]],size=100)

prior_mean=np.array([0,0])
prior_cov=np.array([[2,0],[0,2]])
mean,cov=VI(data_set,prior_mean,prior_cov)
print(mean,cov)
