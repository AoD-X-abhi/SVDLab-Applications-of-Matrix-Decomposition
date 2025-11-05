<div align="center">

# 🧮✨ **Applications of Singular Value Decomposition (SVD)**  
### _Exploring the Power of Matrix Decomposition in Image Processing using MATLAB_

[![MATLAB](https://img.shields.io/badge/MATLAB-R2021a%2B-orange?logo=mathworks)](https://www.mathworks.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![GitHub Repo](https://img.shields.io/badge/Repository-SVD--Applications-blue?logo=github)](https://github.com/<your-username>/SVD-Applications)

</div>

---

## 🧠 **Overview**

**Singular Value Decomposition (SVD)** is a cornerstone of linear algebra, widely applied in image processing, data compression, and pattern recognition.

\[
A = U \Sigma V^T
\]

- **U** → Left singular vectors (orthogonal)  
- **Σ** → Singular values (energy of features)  
- **Vᵗ** → Right singular vectors (orthogonal)

In this repository, we explore **five real-world applications of SVD** implemented in **MATLAB**, each demonstrating the power of matrix decomposition in solving image-related challenges.

---

## 🚀 **Implemented Applications**

### 🧩 1️⃣ Image Compression using SVD

**🎯 Goal:** Reduce image storage while maintaining visual quality.  
**📘 Concept:**  
- Compute SVD of the image matrix  
- Keep top-*k* singular values (low-rank approximation)  
- Reconstruct using reduced matrices  

\[
A_k = U_k \Sigma_k V_k^T, \quad k < \text{rank}(A)
\]

**✨ Results:**
- High-quality reconstruction with reduced file size  
- Adjustable compression ratio  

📸 **Sample Output:**  
![Image Compression](Results/compression_result.png)

---

### 🧹 2️⃣ Image Denoising using SVD

**🎯 Goal:** Remove noise from degraded images using low-rank approximation.  
**📘 Concept:**  
- Perform SVD on noisy image  
- Remove smaller singular values (representing noise)  
- Rebuild clean image using dominant singular components  

🧾 **Observation:**  
Low-rank reconstruction filters out high-frequency noise effectively.

📸 **Sample Output:**  
![Image Denoising](Results/denoising_result.png)

---

### 💧 3️⃣ Image Watermarking using SVD

**🎯 Goal:** Embed watermark (logo/text) into a cover image invisibly yet robustly.  
**📘 Concept:**  
- Apply SVD to both cover & watermark images  
- Modify singular values of cover image using watermark info  
- Reconstruct & later extract watermark using inverse process  

**🔐 Advantages:**
- Robust against compression, scaling, and minor distortions  
- High imperceptibility  

📸 **Sample Output:**  
![Image Watermarking](Results/watermark_result.png)

---

### 🕵️‍♂️ 4️⃣ Image Steganography (Text & Image)

**🎯 Goal:** Hide secret data (text or image) inside another image securely.  
**📘 Concept:**  
- Convert message/image to binary  
- Embed bits into least significant singular values  
- Extract hidden info through inverse SVD  

🔠 **Modes Supported:**
- Text → Image Steganography  
- Image → Image Steganography  

**🔒 Use Cases:**
- Secure data transfer  
- Confidential image sharing  

📸 **Sample Output:**  
![Image Steganography](Results/steganography_result.png)

---

### 🧠 5️⃣ Face Recognition using SVD

**🎯 Goal:** Recognize faces by extracting unique features using SVD.  
**📘 Concept:**  
- Perform SVD on training face images → derive **eigenfaces**  
- Project test image into SVD subspace  
- Classify via minimum Euclidean distance or correlation  

🧾 **Steps:**
1. Convert all faces to grayscale  
2. Compute SVD → extract feature space  
3. Compare projections for recognition  

📊 **Dataset:** ORL or custom face dataset  
📸 **Sample Output:**  
![Face Recognition](Results/face_recognition_output.png)

---

## 🧮 **Mathematical Insight**

SVD distinguishes **essential signal components** (large singular values) from **redundant/noisy data** (small singular values).

| Application | Principle | Key Benefit |
|--------------|------------|--------------|
| Compression | Low-rank approximation | Reduces storage |
| Denoising | Remove small singular values | Noise suppression |
| Watermarking | Modify singular values | Data embedding |
| Steganography | Hide data in singular components | Stealth communication |
| Face Recognition | Feature extraction | Identity classification |

---

## ⚙️ **Requirements**

🧰 **Software:**
- MATLAB R2021a or later  
- Image Processing Toolbox  
- Statistics & Machine Learning Toolbox  

---

## ▶️ **How to Run**

1. Clone the repository:
   ```bash
   git clone https://github.com/<AoD-X-abhi>/SVD-Applications.git
