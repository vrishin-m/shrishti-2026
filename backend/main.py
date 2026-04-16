from fastapi import FastAPI, Request
from fastapi.responses import FileResponse
from pytubefix import YouTube
from audioanalysis import get_final_output, get_peaks
from pydub import AudioSegment
import os, uvicorn, json

app = FastAPI()

#jfp8d_3lGVA

@app.get("/song/{song_id}")
def root(song_id:str, request: Request):
    print(song_id, request.client.host)
    song_url = "https://www.youtube.com/watch?v=" + song_id
    # return song_url
    vid = YouTube(song_url)
    audio_download = vid.streams.get_audio_only()
    temp = audio_download.download(filename="song.mp3")

    # entry = YouTube(urls).title
    print(f"\nVideo found: {vid.title}\n")

    audio = AudioSegment.from_file(temp)
    audio.export("songf.mp3", format="mp3")
    os.remove("song.mp3")

    peaks, energy = get_peaks(f"songf.mp3")
    # edict = {"energy":energy.tolist()}
    data = get_final_output(peaks)
    print(data, energy)

    # return {"data":data, "file":FileResponse(path="songf.mp3", media_type="audio/mpeg"), "energy":energy}
    return FileResponse(path="songf.mp3", media_type="audio/mpeg", headers={"data":json.dumps(data)})

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)

# root("https://www.youtube.com/watch?v=jfp8d_3lGVA")
# uvicorn main:app --host 0.0.0.0 --port 8000
