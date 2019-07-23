cp ${TENSORFLOWPATH}/ObjectDetectionDeps/OrganizeImageDirectory.py ${PWD}
cp ${TENSORFLOWPATH}/ObjectDetectionDeps/RenameImageData.py ${PWD}

mkdir Images
export IMAGEWORKDIR=${PWD}
cd Images
export IMAGEPATH=${PWD}
mkdir Train
cd Train
export TRAININGPATH=${PWD}
cd ..
mkdir Test
cd Test
export TESTINGPATH=${PWD}
cd ..
cd ..
python3 RenameImageData.py
python3 OrganizeImageDirectory.py
cp ${TENSORFLOWPATH}/ObjectDetectionDeps/xml_to_csv.py ${PWD}
cp ${TENSORFLOWPATH}/ObjectDetectionDeps/generate_tfrecord.py ${PWD}
cp ${TENSORFLOWPATH}/ObjectDetectionDeps/labelmap.pbtxt ${PWD}
python3 xml_to_csv.py
python3 generate_tfrecord.py --csv_input=${IMAGEPATH}/Train_labels.csv --image_dir=${TRAININGPATH} --output_path=${IMAGEPATH}/train.record
python3 generate_tfrecord.py --csv_input=${IMAGEPATH}/Test_labels.csv --image_dir=${TESTINGPATH} --output_path=${IMAGEPATH}/test.record
mkdir Model
cd Model
export MODEL_DIR=${PWD}
cd ..
cp ${TENSORFLOWPATH}/Training/CKPT/pipeline.config ${PWD}
sed -i "s|LABELMAP|${IMAGEWORKDIR}/labelmap.pbtxt|g" pipeline.config
sed -i "s|TRAINRECORD|${IMAGEPATH}/train.record|g" pipeline.config
sed -i "s|TESTRECORD|${IMAGEPATH}/test.record|g" pipeline.config
sed -i "s|FINETUNE|${TENSORFLOWPATH}/Training/CKPT/model.ckpt|g" pipeline.config

${TENSORFLOWPATH}/ObjectDetectionDeps/retrain_detection_model.sh