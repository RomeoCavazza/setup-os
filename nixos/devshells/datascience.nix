{ pkgs }:

pkgs.mkShell {
  name = "ds-cuda";

  packages = with pkgs; [
    (python311.withPackages (ps: with ps; [
      numpy pandas scipy scikit-learn matplotlib seaborn
      jupyter notebook ipykernel
      torch-bin torchvision-bin
      tqdm black ruff pynvml
    ]))

    cudaPackages.cudatoolkit
    cudaPackages.cudnn
    cudaPackages.cuda_nvcc

    stdenv.cc.cc.lib
    zlib
  ];

  shellHook = ''
    export CUDA_PATH=${pkgs.cudaPackages.cudatoolkit}
    export LD_LIBRARY_PATH=/run/opengl-driver/lib:${pkgs.cudaPackages.cudatoolkit}/lib64:${pkgs.cudaPackages.cudnn}/lib:${pkgs.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH
    echo "Data Science CUDA Environment Loaded"
    echo "Python: $(python --version)"
    nvidia-smi --query-gpu=name,driver_version --format=csv,noheader || true
  '';
}
