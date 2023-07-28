import std.stdio;
import std.math;

// 计算逆矩阵;
double[100][100] inv(double[100][100] mat) {
	double[100][100*2] ext_mat; // 初始化增广矩阵;
	double[100][100] inv_mat; // 初始化逆矩阵;
	
	// 生成增广矩阵
	for (int row = 0; row < 100; row++) {
		for (int col = 0; col < (100*2); col++) {
			if (col >= 100) {
				if (row == (col-100)) {
					ext_mat[row][col] = 1;
				} else {
					ext_mat[row][col] = 0;
				}
			} else {
				ext_mat[row][col] = mat[row][col];
			}
		}
	}

	// 依次变换成[E|A];
	for (int row1 = 0; row1 < 100; row1++) {
		if (ext_mat[row1][row1]==0) {
			if (row1 == (100-1)) {
				throw new Exception("Invalid Matrix: Inverse Not Exists.");
				break;
			} else {
				for (int row2 = (row1+1); row2 < 100; row2++) {
					if (ext_mat[row2][row1] == 0) {
						continue;
					} else {
						double[] temp_col = ext_mat[row2]; // 以下四行交换主行和非零行;
						ext_mat[row1] = temp_col;
						ext_mat[row2] = ext_mat[row1];
						ext_mat[row1] = temp_col;
						double temp_a = ext_mat[row1][row1]; // 以下两行将主元置1;
						ext_mat[row1] = ext_mat[row1][] / temp_a;
						break;
					} 
				}
			}
		} else {
			if (ext_mat[row1][row1] != 1) {
				double temp_a = ext_mat[row1][row1]; // 以下两行将主元置1;
				ext_mat[row1] = ext_mat[row1][] / temp_a;
			}
			
			for (int row2 = 0; (row2 < 100) && (row2 != row1); row2++) {
				if (ext_mat[row2][row1] == 0) {
					continue;
				} else {
					double[] temp_col = ext_mat[row1]; // 以下三行将非主行的主元置0;
					double temp_b = ext_mat[row2][row1];
					ext_mat[row2][] -= temp_col[] * temp_b;
				}
			}
		}
	}
	
	// 分离出逆矩阵;
	inv_mat[][] = ext_mat[0 .. 100][100 .. 200];
	return inv_mat;
}

// 计算行列式(LU分解);
double det(double[100][100] mat) {
	double[100][100] L_mat; // L矩阵初始化;
	double[100][100] U_mat = mat; // U矩阵初始化;
	double mat_det; // 行列式初始化;
	
	// 计算U矩阵;
	for (int row1 = 0; row1 < 100; row1++) {
		for (int col = 0; col < row1; col++) {
			if (U_mat[row1][row1]==0) {
				if (row1 == (100-1)) {
					mat_det = 0;

					return mat_det; // 如果最末元素为零则行列式为零，因为|U|=0.
				} else {
					for (int row2 = (row1+1); row1 < 100; row1++) {
						if (U_mat[row2][row1] == 0) {
							continue;
						} else {
							double[] temp_col = U_mat[row2];
							U_mat[row2] = U_mat[col];
							U_mat[row1] = temp_col; // 如果主行的主元为零则与主元非零的第一个非主行交换;
						}
					}
				}
			} else {
				for (int row2 = (row1+1); row2 < 100; row2++) {
					if (U_mat[row2][row1] == 0) {
						continue;
					} else {
						double[] temp_col = U_mat[row1]; // 以下三行将下非主行的主元置0;
						L_mat[row2][row1]= U_mat[row2][row1]; // 对应的倍数传入L矩阵;
						U_mat[row2][] -= temp_col[] * L_mat[row2][row1];
					}
				}
			}
		}
	}
	
	// 补充L矩阵;
	for (int row = 0; row < 100; row++) {
		L_mat[row][row] = 1.0;
	}
	
	// 计算行列式;
	double temp_prod_L = 1.0;
	double temp_prod_U = 1.0;

	for (int row = 0; row < 100; row++) {
		temp_prod_L *= L_mat[row][row];
		temp_prod_U *= U_mat[row][row];
	}
	
	mat_det = temp_prod_L * temp_prod_U;
	
	return mat_det;
}

// 多元高斯分布函数;
double multivariate_gausian(double[100] mu_vec, double[100][100] X_mat, int size) {
	double[] x_vec; // x向量;
	double[100][100] X_inv = inv(X_mat); // 精度矩阵初始化;
	double X_det = det(X_mat); // 协方差矩阵的行列式初始化;
	double X_sum = 0; // 高斯分布公式的指数部分初始化;
        
        for (int i = 0; i <= 100; i++) {
            x_vec[i] = i;
        }

	x_vec[] = x_vec[] - 100;
    x_vec[] = x_vec[] / 100; // 控制采样区间:[-1.0, 1.0];

	// 计算指数部分。
	double[100] x1_vec = x_vec[] - mu_vec[];

	for (int col1 = 0; col1 < 100; col1++) {
		for (int row1 = 0; row1 < 100; row1++) {
			for (int col2 = 0; col2 < 100; col2++) {
				X_sum += x1_vec[col1] * X_inv[row1][col2] * x1_vec[col2];
			}
		}
	}

	X_sum *= - 1 / 2; // 乘上系数;

	// 整合公式;
	return exp(X_sum) / (pow(2 * PI, size / 2) * pow(X_det, 1 / 2));

}

void main() {
	double[100] prior_mean; // 
	double[100][100] prior_cov;
	double mean;
	double cov;

	double[100] data_set;

	prior_mean = [ 0, 0 ];
	prior_cov = [ [ 2, 0 ],
				  [ 0, 2 ] ];
	
	writeln("ok!");
	// mean = vbi(data_set, prior_mean, prior_cov)[0];
	// cov = vbi(data_set, prior_mean, prior_cov)[1];
	
	// writeln("mean: ", mean);
	// writeln("cov: ", cov);
}

