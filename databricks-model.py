storage_account_name = "bicorpdatablob"
storage_account_access_key = "P98+lA+5QfgWngaE328pScvjF21fnZFdzH++xttno+SrCOp1dgBwFeGJQpRTsXnJeDXQ9L8E2QT2VqcazjTGeA=="

file_location = "wasbs://corpdataset@bicorpdatablob.blob.core.windows.net/df_pca2.csv"
#https://bicorpdatablob.blob.core.windows.net/corpdataset/2d9301cc4fbaa345.csv
file_type = "csv"

spark.conf.set(
  "fs.azure.account.key."+storage_account_name+".blob.core.windows.net",
  storage_account_access_key)

df = spark.read.format(file_type).option("inferSchema", "false").option("header", "true").load(file_location)

from pyspark.sql import (SQLContext,
                         SparkSession)
from pyspark.sql.functions import isnull, when, count, col
from pyspark.sql.types import (StructType,
                               StructField,
                               DoubleType,
                               IntegerType,
                               StringType,
                               DateType)
df = df.withColumn('rptd_pr',col('rptd_pr').cast(DoubleType()))\
        .withColumn('pca_otpt_features[0]',col('pca_otpt_features[0]').cast(DoubleType()))\
        .withColumn('pca_otpt_features[1]',col('pca_otpt_features[1]').cast(DoubleType()))\
        .withColumn('pca_otpt_features[2]',col('pca_otpt_features[2]').cast(DoubleType()))\
        .withColumn('pca_otpt_features[3]',col('pca_otpt_features[3]').cast(DoubleType()))\
        .withColumn('pca_otpt_features[4]',col('pca_otpt_features[4]').cast(DoubleType()))\
        .withColumn('pca_otpt_features[5]',col('pca_otpt_features[5]').cast(DoubleType()))\
        .withColumn('pca_otpt_features[6]',col('pca_otpt_features[6]').cast(DoubleType()))\
        .withColumn('pca_otpt_features[7]',col('pca_otpt_features[7]').cast(DoubleType()))\
        .withColumn('pca_otpt_features[8]',col('pca_otpt_features[8]').cast(DoubleType()))\
        .withColumn('pca_otpt_features[9]',col('pca_otpt_features[9]').cast(DoubleType()))\
        .withColumn('pca_otpt_features[10]',col('pca_otpt_features[10]').cast(DoubleType()))\
        .withColumn('pca_otpt_features[11]',col('pca_otpt_features[11]').cast(DoubleType()))\
        .withColumn('pca_otpt_features[12]',col('pca_otpt_features[12]').cast(DoubleType()))\
        .withColumn('pca_otpt_features[13]',col('pca_otpt_features[13]').cast(DoubleType()))\
        .withColumn('pca_otpt_features[14]',col('pca_otpt_features[14]').cast(DoubleType()))

from pyspark.ml.linalg import Vectors
from pyspark.ml.feature import VectorAssembler
#trainingData = unmissing_buy_cmsn_rt.rdd.map(lambda x:(Vectors.dense(x[0:-9]), x[-9])).toDF(["features", "label"])
assembler = VectorAssembler(
    inputCols=['pca_otpt_features[0]','pca_otpt_features[1]','pca_otpt_features[2]','pca_otpt_features[3]','pca_otpt_features[4]','pca_otpt_features[5]','pca_otpt_features[6]','pca_otpt_features[7]','pca_otpt_features[8]','pca_otpt_features[9]','pca_otpt_features[10]','pca_otpt_features[11]','pca_otpt_features[12]','pca_otpt_features[13]','pca_otpt_features[14]'],
    outputCol="features")
data = assembler.transform(df)
data = data.withColumnRenamed("rptd_pr","label")


(trainingData, testData) = data.randomSplit([0.7, 0.3])

from pyspark.ml import Pipeline
from pyspark.ml.regression import FMRegressor
from pyspark.ml.feature import MinMaxScaler
from pyspark.ml.evaluation import RegressionEvaluator

# Train a FM model.
fm = FMRegressor(featuresCol="features", stepSize=0.001)

# Create a Pipeline.
pipeline = Pipeline(stages=[fm])

# Train model.
model = pipeline.fit(trainingData)

# Make predictions.
predictions = model.transform(testData)

# Select example rows to display.
#predictions.select("prediction", "label", "features").show(5)

# Select (prediction, true label) and compute test error
#evaluator = RegressionEvaluator(
#    labelCol="label", predictionCol="prediction", metricName="rmse")
#rmse = evaluator.evaluate(predictions)
#print("Root Mean Squared Error (RMSE) on test data = %g" % rmse)

#fmModel = model.stages[1]
#print("Factors: " + str(fmModel.factors))
#print("Linear: " + str(fmModel.linear))
#print("Intercept: " + str(fmModel.intercept))

predictions_outcome = predictions.select('prediction','label')
# Select example rows to display.
#predictionAndLabels = predictions.select("prediction", "label")
#evaluator = MulticlassClassificationEvaluator(metricName="accuracy")
#print("Test set accuracy = " + str(evaluator.evaluate(predictionAndLabels)))

predictions_outcome2 = predictions_outcome.filter(predictions_outcome.label >= 100)

predictions_outcome3 = predictions_outcome2.filter(predictions_outcome2.prediction>=100)

predictions_outcome3 = predictions_outcome3.withColumn('prediction',col('prediction')/10)
predictions_outcome3 = predictions_outcome3.withColumn('label',col('label')/10)

import numpy as np
df_array1 = np.array(predictions_outcome3.select('prediction').take(15))
df_array2 = np.array(predictions_outcome3.select('label').take(15))

import matplotlib
import matplotlib.pyplot as plt

fig = plt.figure()
ax = plt.axes()
plt.plot(df_array1)
plt.plot(df_array2)
plt.show()