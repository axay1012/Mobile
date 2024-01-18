import requests
import time

class AssemblyAITranscriber:
    def __init__(self):
        self.base_url = "https://api.assemblyai.com/v2"
        self.headers = {
            "authorization": "53957275411a4c0b9d2ecf8576c3bd0b"
        }

    def upload_audio(self, audio_file_path):
        with open(audio_file_path, "rb") as f:
            response = requests.post(self.base_url + "/upload",
                                     headers=self.headers,
                                     data=f)
        upload_url = response.json()["upload_url"]
        return upload_url

    def request_transcription(self, upload_url):
        data = {
            "audio_url": upload_url
        }
        url = self.base_url + "/transcript"
        response = requests.post(url, json=data, headers=self.headers)
        transcript_id = response.json()['id']
        return transcript_id

    def check_transcription_status(self, transcript_id):
        polling_endpoint = f"{self.base_url}/transcript/{transcript_id}"
        while True:
            transcription_result = requests.get(polling_endpoint, headers=self.headers).json()
            if transcription_result['status'] == 'completed':
                return transcription_result['text']
            elif transcription_result['status'] == 'error':
                raise RuntimeError(f"Transcription failed: {transcription_result['error']}")
            else:
                time.sleep(3)
