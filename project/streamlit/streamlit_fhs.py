import streamlit as st
import joblib
import pandas as pd
import matplotlib.pyplot as plt
from wordcloud import WordCloud
import joblib

# funciones

def prepara_df(df_pred):
    #  'SENWT'
    dict_SENWT={'España':0.01, "Francia":0.2, "Alemania":1.7, "Reino Unido":1}
    df_pred['SENWT'] = df_pred['SENWT'].map(dict_SENWT)
    # OCOD3
    dict_OCOD3={"Managers": 9000, "Professional": 8000, "Technicians and associate professionals": 7000,
    "Clerical support workers": 6000,
    "Service and sales workers": 5000,
    "Skilled agricultural, forestry and fishery workers": 4000,
    "Craft related trades workers": 3000,
    "Plant and machine operators, and assemblers": 2000,
    "Elementary occupations": 1000}
    df_pred['OCOD3'] = df_pred['OCOD3'].map(dict_OCOD3)
    # MASTGOAL
    dict_MASTGOAL= {"High school diploma":-2.5, "Undergraduate degree":-1.25, "Postgraduate degree":1.25, "PhD":2.5}
    df_pred['MASTGOAL'] = df_pred['MASTGOAL'].map(dict_MASTGOAL)

    # GCSELFEFF
    dict_GCSELFEFF= {"0":-2.5,"25":-1.25,"75":1.25,"100":2.5}
    df_pred['GCSELFEFF'] = df_pred['GCSELFEFF'].map(dict_GCSELFEFF)
    # ST001D01T
    dict_ST001D01T= {"Sí":7, "No":10}
    df_pred['ST001D01T'] = df_pred['ST001D01T'].map(dict_ST001D01T)
    # BSMJ
    dict_BSMJ= {"En activo":100, "Paro":0, "Estudiante":50}
    df_pred['BSMJ'] = df_pred['BSMJ'].map(dict_BSMJ)
    # GCAWARE
    dict_GCAWARE= {"0":-2.5,"25":-1.25,"75":1.25,"100":2.5}
    df_pred['GCAWARE'] = df_pred['GCAWARE'].map(dict_GCAWARE)

    df_pred['Score_pond']=(df_pred['BSMJ']+df_pred['ST001D01T']+df_pred['GCAWARE'])*score_cluster0+(df_pred['PV9MATH']+df_pred['PV9READ']+df_pred['PV3READ']+df_pred['PV1GLCM'])*score_cluster1+(df_pred['PV8RTSN']
            +df_pred['PV10RCER']+df_pred['MASTGOAL']+df_pred['PV4RCER']+df_pred['PV4RTML']+df_pred['PV10RTSN']+df_pred['PV4RCLI']+df_pred['PV1RCER']+df_pred['PV7RCUN']+df_pred['PV1RTML']+df_pred['PV3RCUN']+df_pred['PV5RTSN']+df_pred['PV6RTSN']+df_pred['PV8RTML']
            +df_pred['PV3RCER']+df_pred['PV9RCLI']+df_pred['PV8RCLI']+df_pred['PV6RTML']+df_pred['PV8RCUN']+df_pred['PV3RTSN']+df_pred['PV2RTSN']+df_pred['PV7RCER']+df_pred['PV8RCER']+df_pred['PV9RTSN']+df_pred['PV10RTML']
            +df_pred['PV6RCER']+df_pred['PV5RCUN']+df_pred['PV10RCLI']+df_pred['PV7RTML'])*score_cluster2+(df_pred['OCOD3']+df_pred['SENWT']+df_pred['GCSELFEFF'])*score_cluster4


    return df_pred

# precargo el modelo

model_riesgo=joblib.load('/app/bootcamp_bd-ai-ml/project/streamlit/models/RiesgoAbandono/knn_st.joblib')

# scores de twitter
score_cluster0=float(0.23068260869565216)
score_cluster1=float(0.03286976744186046)
score_cluster2=0.07773206106870229
score_cluster3=0.1646877551020408
score_cluster4=0.08664
# pagina



st.title(":blue[Riesgo de abandano escolar]")

st.header("¿Cuales de estos factores crees están más relacionados con el abandono escolar?") 


librosencasa = st.checkbox('Tener menos de 10 libros en casa.')
videojuegos = st.checkbox('Pasar más de 2h al día jugando a videojuegos o viendo la televisión.')
padres = st.checkbox('Los padres han sufrido abandono escolar.')

if st.button('Ver resultados'):
    if librosencasa and not videojuegos and not padres:
        st.write('***Has acertado 1 de 3! Intentalo de nuevo***')
        st.write('Efectivamente! Un mayor número de libros en casa se relaciona con tasas menores de abandono.')
    if videojuegos and not librosencasa and not padres:
        st.write('***Has acertado 1 de 3! Intentalo de nuevo***')
        st.write('Exacto! Menos horas de dispositivos electrónicos favorece a los estudios.')
    if padres and not librosencasa and not videojuegos:
        st.write('***Has acertado 1 de 3! Intentalo de nuevo***')
        st.write('Correcto, se debería prestar especial atención si los padres ha tenido abandono escolar.')
    if librosencasa and videojuegos and not padres:
        st.write('***Has acertado 2 de 3! Intentalo de nuevo***')
        st.write('Efectivamente! Un mayor número de libros en casa se relaciona con tasas menores de abandono.')
        st.write('Exacto! Menos horas de dispositivos electrónicos favorece a los estudios.')
    if padres and videojuegos and not librosencasa:
        st.write('***Has acertado 2 de 3! Intentalo de nuevo***')
        st.write('Correcto, se debería prestar especial atención si los padres ha tenido abandono escolar.')
        st.write('Exacto! Menos horas de dispositivos electrónicos favorece a los estudios.')
    if padres and librosencasa and not videojuegos:
        st.write('***Has acertado 2 de 3! Intentalo de nuevo***')
        st.write('Efectivamente! Un mayor número de libros en casa se relaciona con tasas menores de abandono.')
        st.write('Correcto, se debería prestar especial atención si los padres ha tenido abandono escolar.')
    if padres and librosencasa and videojuegos:
        st.write('** Has acertado 3 de 3! Bien hecho! :sunglasses: **')
    if not padres and not librosencasa and not videojuegos:
        st.write('***No has acertado ninguna respuesta*** :frowning_face: , intentalo de nuevo!')



st.header("Elige un palabra para ver las palabras relacionadas en twitter") 
# topics entre los que se puede seleccionar
topic1 = 'Education'
topic2 = 'lessons'
topic3 = 'school'
topic4 = 'teacher'

topic = st.selectbox('Selecciona una palabra',[topic1,topic2,topic3,topic4])

st.write('Has seleccionado:', topic)

# Create and generate a word cloud image:
def create_wordcloud(topic):
    word=list(pd.read_csv('/app/bootcamp_bd-ai-ml/project/streamlit/wordclouds/words_'+str(topic)+'.csv')['0'])

    wordcloud = WordCloud(max_font_size=50, max_words=100,font_path="/app/bootcamp_bd-ai-ml/project/streamlit/fonts/arial/arial.ttf", background_color="white").generate(' '.join(word))
    return wordcloud


wordcloud = create_wordcloud(topic)
fig, ax = plt.subplots(figsize = (12, 8))
ax.imshow(wordcloud)
plt.axis("off")
st.pyplot(fig)



st.header("¿Te gustaría conocer tu riesgo de abandono escolar? Contesta a preguntas para averiguarlo :smile:") 


#columnas para ordenar la pagina
col1, col2, col3 = st.columns(3)

# getting user input. Cada pregunta será una variable

factor_correcc=10

SENWT =  col1.selectbox("Escoge el país donde vives",["España", "Francia", "Alemania", "Reino Unido"])
OCOD3 =  col2.selectbox("Escoge el tipo de ocupación a la que te gustaría dedicarte entre los siguientes grupos principales:",["Managers","Professional","Technicians and associate professionals","Clerical support workers","Service and sales workers","Skilled agricultural, forestry and fishery workers","Craft related trades workers","Plant and machine operators, and assemblers","Elementary occupations"])
CNTSCHID = 1000

MASTGOAL =  col3.selectbox("¿Qué tipo de estudios te gustaría terminar?",["High school diploma", "Undergraduate degree", "Postgraduate degree", "PhD"])
GCSELFEFF =  col1.selectbox("¿Te consideras una persona eficaz globalmente? Valora entre 0 y 100",["0","25","75","100"])
ST001D01T =  col2.selectbox("¿Eres un estudiante internacional?",["Sí","No"])
BSMJ =  col3.selectbox("¿Cuál es el estado laboral que esperas al acabar tus estudios?",["En activo", "Paro", "Estudiante"])
GCAWARE =  col1.selectbox("Conciencia del estudiante sobre los problemas globales. Valora del 0 al 100.",["0","25","75","100"])
PV9MATH =  col2.slider("Valora tus competencias en matemáticas", 0, 100, 25)*factor_correcc
PV3READ =  col3.slider("Valora tus competencias en comprensión lectora", 0, 100, 25)*factor_correcc
# PV9READ =  col1.slider("Valora tus competencias en comprensión lectora de lengua extranjera", 0, 100, 25)
PV9READ=PV3READ
PV1GLCM =  col2.slider("Valora tus competencias generales en lectura y escritura", 0, 100, 25)*factor_correcc
PV4RCLI =  col3.slider("Valora tus competencias lectoras para la búsqueda información", 0, 100, 25)*factor_correcc
# PV8RCLI =  col1.slider("Valora tus competencias lectoras para la búsqueda información en libros ", 0, 100, 25)
# PV9RCLI =  col2.slider("Valora tus competencias lectoras para la búsqueda información en archivos y enciclopedias", 0, 100, 25)
# PV10RCLI =  col3.slider("Valora tus competencias lectoras para la búsqueda información en otros medios", 0, 100, 25)
PV8RCLI=PV4RCLI
PV9RCLI=PV4RCLI
PV10RCLI=PV4RCLI
PV3RCUN =  col1.slider("Valora tus competencias lectoras para entender la información y extraer tus propias conclusiones", 0, 100, 25)*factor_correcc
# PV5RCUN =  col2.slider("Valora tus competencias lecturas para entender la información en libros ", 0, 100, 25)
# PV7RCUN =  col3.slider("Valora tus competencias lecturas para entender la información en archivos y enciclopedias", 0, 100, 25)
# PV8RCUN =  col1.slider("Valora tus competencias lecturas para entender la información en otros medios", 0, 100, 25)
PV5RCUN = PV3RCUN
PV7RCUN = PV3RCUN
PV8RCUN = PV3RCUN
PV1RCER =  col2.slider("Valora tus competencias lectoras para reflexionar de forma crítica sobre la información", 0, 100, 25)*factor_correcc
# PV3RCER =  col3.slider("Valora tus competencias lectoras para contrastar fuentes de información", 0, 100, 25)
# PV4RCER =  col1.slider("Valora tus competencias lectoras para extraer diferencias entre fuentes de información", 0, 100, 25)
# PV6RCER =  col2.slider("Valora tus competencias lectoras para elaborar tus propias conclusiones", 0, 100, 25)
# PV7RCER =  col3.slider("Valora tus competencias lectoras para evaluar la veracidad de la información", 0, 100, 25)
PV3RCER = PV1RCER
PV4RCER = PV1RCER
PV6RCER = PV1RCER
PV7RCER = PV1RCER
PV8RCER = PV1RCER
PV10RCER = PV1RCER

PV2RTSN =  col3.slider("Valora tus competencias lectoras para leer un único texto y extraer la información más relevante", 0, 100, 25)*factor_correcc
PV3RTSN = PV2RTSN
PV5RTSN = PV2RTSN
PV6RTSN = PV2RTSN
PV8RTSN = PV2RTSN
PV9RTSN = PV2RTSN
PV10RTSN = PV2RTSN

PV1RTML =  col1.slider("Valora tus competencias lectoras para leer varios textos y extraer la información más relevante", 0, 100, 25)*factor_correcc
PV4RTML = PV1RTML
PV6RTML = PV1RTML
PV7RTML = PV1RTML
PV8RTML = PV1RTML
PV10RTML = PV1RTML






# TRANSFORMAMOS DATOS DE FORMULARIO PARA EL MODELO

df_pred = pd.DataFrame([[ SENWT , OCOD3 ,CNTSCHID, MASTGOAL , GCSELFEFF , ST001D01T 	, BSMJ ,	 GCAWARE ,	 PV9MATH ,	 PV3READ ,	 PV9READ ,	 PV1GLCM ,	 PV4RCLI ,	 PV8RCLI , PV9RCLI , PV10RCLI ,	 PV3RCUN , PV5RCUN , PV7RCUN , PV8RCUN , PV1RCER ,	 PV3RCER ,	 PV4RCER ,	 PV6RCER ,	 PV7RCER ,	 PV8RCER ,	 PV10RCER ,	 PV2RTSN ,	 PV3RTSN ,	 PV5RTSN ,	 PV6RTSN ,	 PV8RTSN ,	 PV9RTSN ,	 PV10RTSN ,	 PV1RTML ,	 PV4RTML ,	 PV6RTML ,	 PV7RTML ,	 PV8RTML ,	 PV10RTML]])
                     
columns= ['SENWT','OCOD3','CNTSCHID','MASTGOAL','GCSELFEFF','ST001D01T'	,'BSMJ',	'GCAWARE',	'PV9MATH',	'PV3READ',	'PV9READ',	'PV1GLCM',	'PV4RCLI',	'PV8RCLI','PV9RCLI','PV10RCLI',	'PV3RCUN','PV5RCUN','PV7RCUN','PV8RCUN','PV1RCER',	'PV3RCER',	'PV4RCER',	'PV6RCER',	'PV7RCER',	'PV8RCER',	'PV10RCER',	'PV2RTSN',	'PV3RTSN',	'PV5RTSN',	'PV6RTSN',	'PV8RTSN',	'PV9RTSN',	'PV10RTSN',	'PV1RTML',	'PV4RTML',	'PV6RTML',	'PV7RTML',	'PV8RTML',	'PV10RTML']
df_pred.columns=columns
print(df_pred)  


if st.button('Predict'):
    st.write('realizando prediccion...')
    df_pred=prepara_df(df_pred)
    print(df_pred)
    # df_pred.to_csv('ej2.csv')
    # df_pred=scaler_riesgo.transform(df_pred)
    # print(df_pred)  
    pred_riesgo=model_riesgo.predict(df_pred)
    
    
    st.write(pred_riesgo[0])
    
    if(pred_riesgo[0]==0):
        st.write('Tu riesgo de abandono escolar es bajo.',unsafe_allow_html=True)
    elif(pred_riesgo[0]==1):
        st.write('Tu riesgo de abandono escolar es medio.',unsafe_allow_html=True)
    else:
        st.write('<p class="big-font">Tu riesgo de abandono escolar es alto. </p>',unsafe_allow_html=True)





    

