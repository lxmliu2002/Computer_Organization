#include <bits/stdc++.h>
#include <chrono>
#include <thread>

using namespace std;
using namespace std::chrono;

// ����˷������ն�����㣩
vector<vector<int>> matrixMultiplication(const vector<vector<int>>& matrix1, const vector<vector<int>>& matrix2) {
    int rows1 = matrix1.size();
    int cols1 = matrix1[0].size();
    int rows2 = matrix2.size();
    int cols2 = matrix2[0].size();

    if (cols1 != rows2) {
        cout << "Error: The number of columns in matrix1 should be equal to the number of rows in matrix2." << endl;
        return {};
    }

    vector<vector<int>> result(rows1, vector<int>(cols2, 0));

    for (int i = 0; i < rows1; i++) {
        for (int j = 0; j < cols2; j++) {
            for (int k = 0; k < cols1; k++) {
                result[i][j] += matrix1[i][k] * matrix2[k][j];
            }
        }
    }

    return result;
}

// �Ż��ľ���˷����ֿ����˷���
vector<vector<int>> optimizedMatrixMultiplication(const vector<vector<int>>& matrix1, const vector<vector<int>>& matrix2) {
    int rows1 = matrix1.size();
    int cols1 = matrix1[0].size();
    int rows2 = matrix2.size();
    int cols2 = matrix2[0].size();

    if (cols1 != rows2) {
        cout << "Error: The number of columns in matrix1 should be equal to the number of rows in matrix2." << endl;
        return {};
    }

    vector<vector<int>> result(rows1, vector<int>(cols2, 0));

    // ������С
    const int blockSize = 16;

    for (int i = 0; i < rows1; i += blockSize) {
        for (int j = 0; j < cols2; j += blockSize) {
            for (int k = 0; k < cols1; k += blockSize) {
                // ���ӿ���г˷�����
                for (int ii = i; ii < min(i + blockSize, rows1); ii++) {
                    for (int jj = j; jj < min(j + blockSize, cols2); jj++) {
                        for (int kk = k; kk < min(k + blockSize, cols1); kk++) {
                            result[ii][jj] += matrix1[ii][kk] * matrix2[kk][jj];
                        }
                    }
                }
            }
        }
    }

    return result;
}

// ������ɾ���
vector<vector<int>> generateMatrix(int rows, int cols) {
    vector<vector<int>> matrix(rows, vector<int>(cols, 0));

    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            matrix[i][j] = rand() % 100;  // ����0��99֮����������
        }
    }

    return matrix;
}

// ��ӡ����
void printMatrix(const vector<vector<int>>& matrix) {
    int rows = matrix.size();
    int cols = matrix[0].size();

    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            cout << matrix[i][j] << " ";
        }
        cout << endl;
    }
}

// ���м������˷�
vector<vector<int>> parallelMatrixMultiplication(const vector<vector<int>>& matrix1, const vector<vector<int>>& matrix2) {
    int rows1 = matrix1.size();
    int cols1 = matrix1[0].size();
    int rows2 = matrix2.size();
    int cols2 = matrix2[0].size();

    if (cols1 != rows2) {
        cout << "Error: The number of columns in matrix1 should be equal to the number of rows in matrix2." << endl;
        return {};
    }

    vector<vector<int>> result(rows1, vector<int>(cols2, 0));

    const int numThreads = thread::hardware_concurrency();
    vector<thread> threads;

    // �����߳�
    for (int t = 0; t < numThreads; t++) {
        threads.emplace_back([&, t]() {
            for (int i = t; i < rows1; i += numThreads) {
                for (int j = 0; j < cols2; j++) {
                    for (int k = 0; k < cols1; k++) {
                        result[i][j] += matrix1[i][k] * matrix2[k][j];
                    }
                }
            }
            });
    }

    // �ȴ��߳����
    for (auto& thread : threads) {
        thread.join();
    }

    return result;
}

int main() {
    const int minSize = 1024;
    const int maxSize = 4096;
    const int step = 1024;

    for (int size = minSize; size <= maxSize; size += step) {
        cout << "Matrix size: " << size << "x" << size << endl;

        vector<vector<int>> matrix1 = generateMatrix(size, size);
        vector<vector<int>> matrix2 = generateMatrix(size, size);

        // ���ն������ľ���˷�
        auto startTime = high_resolution_clock::now();
        vector<vector<int>> result1 = matrixMultiplication(matrix1, matrix2);
        auto endTime = high_resolution_clock::now();
        auto duration1 = duration_cast<milliseconds>(endTime - startTime).count();
        cout << "Matrix multiplication (definition): " << duration1 << " ms" << endl;

        // �Ż��ľ���˷�
        startTime = high_resolution_clock::now();
        vector<vector<int>> result2 = optimizedMatrixMultiplication(matrix1, matrix2);
        endTime = high_resolution_clock::now();
        auto duration2 = duration_cast<milliseconds>(endTime - startTime).count();
        cout << "Matrix multiplication (optimized): " << duration2 << " ms" << endl;

        // ���м������˷�
        startTime = high_resolution_clock::now();
        vector<vector<int>> result3 = parallelMatrixMultiplication(matrix1, matrix2);
        endTime = high_resolution_clock::now();
        auto duration3 = duration_cast<milliseconds>(endTime - startTime).count();
        cout << "Matrix multiplication (parallel): " << duration3 << " ms" << endl;

        // �����������ܺͼ��ٱ�
        double performance1 = static_cast<double>(size * size * size * 2) / duration1;
        double performance2 = static_cast<double>(size * size * size * 2) / duration2;
        double performance3 = static_cast<double>(size * size * size * 2) / duration3;
        double speedup2 = static_cast<double>(duration1) / duration2;
        double speedup3 = static_cast<double>(duration1) / duration3;

        cout << "Performance (definition): " << performance1 << " FLOPS" << endl;
        cout << "Performance (optimized): " << performance2 << " FLOPS" << endl;
        cout << "Performance (parallel): " << performance3 << " FLOPS" << endl;
        cout << "Speedup (optimized): " << speedup2 << "x" << endl;
        cout << "Speedup (parallel): " << speedup3 << "x" << endl;

        // ������Ƿ�һ��
        if (result1 != result2 || result1 != result3) {
            cout << "Error: Matrix multiplication results are different!" << endl;
        }
    }

    return 0;
}
