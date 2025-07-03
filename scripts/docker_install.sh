#!/bin/bash

apt-get update
apt-get install -y libglu1-mesa libxi-dev libxmu-dev libglu1-mesa-dev \
    freeglut3-dev libosmesa6-dev libyaml-dev git wget libglib2.0-0

python -m pip install --upgrade pip
pip install Cython==0.29.37 fvcore gdown
pip install -r /workspace/MotionBERT/requirements.txt

mkdir -p /workspace/MotionBERT/downloads
cd /workspace/MotionBERT/downloads
git clone https://github.com/MVIG-SJTU/AlphaPose.git

cd /workspace/MotionBERT/downloads/AlphaPose
export PATH=/usr/local/cuda/bin/:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64/:$LD_LIBRARY_PATH
python setup.py build develop

cd /workspace/MotionBERT/downloads/
gdown https://drive.google.com/uc?id=1S-ROA28de-1zvLv-hVfPFJ5tFBYOSITb
cd /workspace/MotionBERT/downloads/AlphaPose/detector/yolo
mkdir -p data
cd data
wget https://huggingface.co/spaces/trild/aimodels/resolve/main/halpe26_fast_res50_256x192.pth -O halpe26_fast_res50_256x192.pth

cd /workspace/MotionBERT/
mkdir -p checkpoint/pose3d/FT_MB_lite_MB_ft_h36m_global_lite/
cd checkpoint/pose3d/FT_MB_lite_MB_ft_h36m_global_lite/
wget https://huggingface.co/walterzhu/MotionBERT/resolve/main/checkpoint/pose3d/FT_MB_lite_MB_ft_h36m_global_lite/best_epoch.bin -O best_epoch.pkl

cd /workspace/MotionBERT/
mkdir -p checkpoint/mesh/FT_MB_release_MB_ft_pw3d/
cd checkpoint/mesh/FT_MB_release_MB_ft_pw3d/
wget https://huggingface.co/walterzhu/MotionBERT/resolve/main/checkpoint/mesh/FT_MB_release_MB_ft_pw3d/best_epoch.bin -O best_epoch.pkl

mkdir -p /workspace/MotionBERT/data/mesh
cd /workspace/MotionBERT/data/mesh
wget https://github.com/githubcrj/simplify/raw/refs/heads/master/code/models/basicModel_neutral_lbs_10_207_0_v1.0.0.pkl -O SMPL_NEUTRAL.pkl
cp -rv /workspace/MotionBERT/configs/mesh/*.np* .