# Python Utility for Alexa Automation


import gtts
from time import sleep
import os
import sys
from robot.api import logger
from googletrans import Translator
import pyaudio
import wave
from pydub import AudioSegment
from AssemblyAITranscriber import *

translator = Translator()

SUPPORTED_LANG = ['english', 'french', 'spanish']
LANGUAGES_CODE = {
    'english': 'en',
    'french': 'fr',
    'spanish': 'es',
}


class voiceskill_helper(object):
    def __init__(self):
        pass

    def delete_file(self, filename):
        logger.console("Deleting the file : {}".format(filename))
        if os.path.exists(filename):
            os.remove(filename)
        else:
            logger.console("The file  {} does not exist".format(filename))

    def convert_text_to_speech(self, curr_text, language='english'):
        """
        Method to convert text response to speech (Alexa commands)

        Steps:-
        (1) Receive Text Formatted Question
        (2) Convert text to speech format using gtts library
        (3) Save the response into the mp3 format
        (4) Convert the mp3 format to wav format

        :param text: Alexa Command
        :return None
        """
        logger.console("Converting the text:- {}".format(curr_text))

        # check for the supported language
        if not language in SUPPORTED_LANG:
            logger.console("\n\n\tPlease Provide Supported language:- {}\n\n".format(SUPPORTED_LANG))
            sys.exit()
        else:
            logger.console("Provided language: {}".format(language))
            current_language = LANGUAGES_CODE[language]

        self.delete_file('command.mp3')

        if language == 'french':
            text = translator.translate(curr_text, dest='fr').text

            print("Text translated to French: {}".format(text))
        elif language == 'spanish':
            text = translator.translate(curr_text, dest='es').text
            print("Text translated to Spanish: {}".format(text))
        else:
            text = curr_text
        # Using gtts Python module to text convertion
        text_to_speech = gtts.gTTS(text=text, lang=current_language, slow=True)

        # save the audio received in the mo3/wav file
        text_to_speech.save("command.mp3")

        # play the mp3 audio file
        os.system(' ffplay -loglevel quiet -nodisp -autoexit  command.mp3 ')

    def mic_to_text(self):
        """
        Method to convert Alexa response to text for further verification

        Steps:-
        (1) Keep the microphone ON to listen the alexa response
        (2) Convert the Alexa response to text
        (3) Verify the text received with the expected output

        :param None
        :return None
        """
        self.delete_file('Output_Command.wav')
        self.record_audio()
        try:
            obj = AssemblyAITranscriber()
            upload_url = obj.upload_audio("Output_Command.wav")
            transcript_id = obj.request_transcription(upload_url)
            transcript_text = obj.check_transcription_status(transcript_id)
            logger.console(transcript_text)
            print(transcript_text)
            return transcript_text
        except :
            return False
    def alexa_comm(self, question, expected_response, language):
        """
        Steps:
        (1) Get the Question and language which will ask to Alexa
        (2) Get the Response from the Alexa
        (3) Compare the Response received and expected data
        (4) If both are different, repeat Step 1 to 3.

        """
        logger.console(
            "\n\tQuestion: {}\n\t Expected answer: {}\n\tlanguage:{}\n".format(question, expected_response, language))
        response_data = []
        for count in range(2):
            logger.console("\nCount {}:   \n".format(count))
            self.convert_text_to_speech(question, language=language)
            sleep(0.5)
            response_received = self.mic_to_text()
            response_status = False
            if response_received:
                response_status = True
                response_data = response_received
                # response_data = response_received.split()
                logger.console("Data received: {}".format(response_data))
                break
            else:
                logger.console("Response from Google was not received. Trying again")
                sleep(1)

        return response_status, response_data

    def alexa_mute(self, question, language):
        """
        Validation of Alexa mute status
        Steps:
        (1) Get the Question and language which will ask to Alexa
        (2) Get the Response from the Alexa
        (3) Compare the Response received and expected data
        (4) If both are different, repeat Step 1 to 3.

        """
        logger.console("\n\tQuestion: {}\n\t language:{}\n".format(question, language))

        sleep(2)
        self.convert_text_to_speech(question, language=language)
        response_received = self.mic_to_text(language=language)
        response_status = False

        if response_received:
            logger.console("Speaker Said : {}".format(response_received.split()))
            response_status = True
        return response_status

    def record_audio(self, seconds = 10 , output_file='output_command.mp3', sample_rate=44100, channels=1, chunk=1024,
                     format=pyaudio.paInt16):
        audio = pyaudio.PyAudio()
        stream = audio.open(format=format, channels=channels,
                            rate=sample_rate, input=True,
                            frames_per_buffer=chunk)
        frames = []
        logger.console("Recording...")
        for i in range(0, int(sample_rate / chunk * seconds)):
            data = stream.read(chunk)
            frames.append(data)
        logger.console("Recording finished.")
        stream.stop_stream()
        stream.close()
        audio.terminate()
        wave_output = wave.open("temp.wav", 'wb')
        wave_output.setnchannels(channels)
        wave_output.setsampwidth(audio.get_sample_size(format))
        wave_output.setframerate(sample_rate)
        wave_output.writeframes(b''.join(frames))
        wave_output.close()
        sound = AudioSegment.from_wav("temp.wav")
        sound.export(output_file, format="mp3")
        print(f"Audio saved as {output_file}")
        self.convert_to_wav()

    def convert_to_wav(self):
        # Load the audio file using pydub
        audio = AudioSegment.from_file('output_command.mp3')

        if audio.channels != 2:
            audio = audio.set_channels(2)
        if audio.sample_width != 2:
            audio = audio.set_sample_width(2)
        audio.export("Output_Command.wav", format="wav")
        sleep(1)

if __name__ == '__main__':
    text = 'Alexa, Discover My Devices'
    name_age = 'Alexa ... what is temperature of My Room?'
    text2 = 'Alexa ...set My Room temperature to 100 degree'
    increase_volume = 'Alexa ...Turn Off My Room'
    set_volume_level = 'Alexa ... Turn on My Room'
    math_1 = 'Alexa... what... is the...result... of... five...plus... five'
    first_alert = 'Alexa... when... was...  first... alert... organization... founded...'
    text11 = "Alexa...qui... est... le... premier... ministre de l'inde"

    Alexa_test = voiceskill_helper()

    # Name Question
    # Alexa_test.mic_to_text()
    expected_name = ['Set']
    Alexa_test.alexa_comm(question=text, expected_response=expected_name, language='english')
    name_status, name_data = Alexa_test.alexa_comm(question=name_age, expected_response=expected_name,
                                                   language='english')
    Alexa_test.alexa_comm(question=text2, expected_response=expected_name,
                                                   language='english')
    Alexa_test.alexa_comm(question=increase_volume, expected_response=expected_name,
                          language='english')
    Alexa_test.alexa_comm(question=set_volume_level, expected_response=expected_name,
                          language='english')

