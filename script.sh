#!/bin/bash

# Create results directories
ligands=("Kaempferol" "Myricetin")
for ligand in "${ligands[@]}"; do
  mkdir -p "results/$ligand"
done

# Variables
receptor="clean_2063.pdbqt"
ligand_files=("Kaempferol.pdbqt" "Myricetin.pdbqt")
center_x=67.24144715447154
center_y=27.296000813008128
center_z=-0.5556158536585366
size_x=20
size_y=20
size_z=20
seed=12345
exhaustiveness=8
num_modes=10

# File check before running
echo "Checking input files..."
if [ ! -f "$receptor" ]; then
  echo "Error: receptor file '$receptor' not found."
  exit 1
fi

for ligand in "${ligand_files[@]}"; do
  if [ ! -f "$ligand" ]; then
    echo "Error: ligand file '$ligand' not found."
    exit 1
  fi
done

# Docking loop
for i in "${!ligands[@]}"; do
  ligand_name="${ligands[$i]}"
  ligand_file="${ligand_files[$i]}"
  out_dir="results/$ligand_name"

  echo "Running docking for $ligand_name..."
  vina --receptor "$receptor" \
       --ligand "$ligand_file" \
       --center_x $center_x --center_y $center_y --center_z $center_z \
       --size_x $size_x --size_y $size_y --size_z $size_z \
       --seed $seed \
       --exhaustiveness $exhaustiveness \
       --num_modes $num_modes \
       --out "${out_dir}/${ligand_name}_output.pdbqt" \
       --log "${out_dir}/${ligand_name}_log.txt"

  echo "Done: results saved in $out_dir/"
done

echo "All docking runs complete."
