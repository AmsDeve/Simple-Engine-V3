package;

import flixel.FlxG;

class Highscore
{

	#if (haxe >= "4.0.0")
	public static var songScores:Map<String, Int> = new Map();
	public static var songMisses:Map<String, Int> = new Map();
	public static var songRating:Map<String, Int> = new Map();
	public static var songBreaks:Map<String, Int> = new Map();
	public static var songGoodHits:Map<String, Int> = new Map();
	#else
	public static var songScores:Map<String, Int> = new Map();
	public static var songMisses:Map<String, Int> = new Map();
	public static var songRating:Map<String, Int> = new Map();
	public static var songBreaks:Map<String, Int> = new Map();
	public static var songGoodHits:Map<String, Int> = new Map();
	#end

	public static function saveScore(song:String, score:Int = 0, ?diff:Int = 0):Void
	{
		var daSong:String = formatSong(song, diff);


		#if !switch
		NGio.postScore(score, song);
		#end


		if (songScores.exists(daSong))
		{
			if (songScores.get(daSong) < score)
				setScore(daSong, score);
		}
		else
			setScore(daSong, score);
	}

	public static function saveMiss(song:String, misses:Int = 0, ?diff:Int = 0):Void
		{
			var daSong:String = formatSong(song, diff);
	
	
			#if !switch
			NGio.postScore(misses, song);
			#end
	
	
			if (songMisses.exists(daSong))
			{
				if (songMisses.get(daSong) < misses)
					setMiss(daSong, misses);
			}
			else
				setMiss(daSong, misses);
		}

		public static function saveHits(song:String, hits:Int = 0, ?diff:Int = 0):Void
			{
				var daSong:String = formatSong(song, diff);
		
		
				#if !switch
				NGio.postScore(hits, song);
				#end
		
		
				if (songGoodHits.exists(daSong))
				{
					if (songGoodHits.get(daSong) < hits)
						setHits(daSong, hits);
				}
				else
					setHits(daSong, hits);
			}

			public static function saveBreaks(song:String, breaks:Int = 0, ?diff:Int = 0):Void
				{
					var daSong:String = formatSong(song, diff);
			
			
					#if !switch
					NGio.postScore(breaks, song);
					#end
			
			
					if (songBreaks.exists(daSong))
					{
						if (songBreaks.get(daSong) < breaks)
							setBreaks(daSong, breaks);
					}
					else
						setBreaks(daSong, breaks);
				}

		public static function saveRating(song:String, rating:Int = 0, ?diff:Int = 0):Void
			{
				var daSong:String = formatSong(song, diff);
		
		
				#if !switch
				NGio.postScore(rating, song);
				#end
		
		
				if (songRating.exists(daSong))
				{
					if (songRating.get(daSong) < rating)
						setRating(daSong, rating);
				}
				else
					setRating(daSong, rating);
			}

	public static function saveWeekScore(week:Int = 1, score:Int = 0, ?diff:Int = 0):Void
	{

		#if !switch
		NGio.postScore(score, "Week " + week);
		#end


		var daWeek:String = formatSong('week' + week, diff);

		if (songScores.exists(daWeek))
		{
			if (songScores.get(daWeek) < score)
				setScore(daWeek, score);
		}
		else
			setScore(daWeek, score);
	}

	/**
	 * YOU SHOULD FORMAT SONG WITH formatSong() BEFORE TOSSING IN SONG VARIABLE
	 */
	static function setScore(song:String, score:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songScores.set(song, score);
		FlxG.save.data.songScores = songScores;
		FlxG.save.flush();
	}

	static function setMiss(song:String, misses:Int):Void
		{
			// Reminder that I don't need to format this song, it should come formatted!
			songMisses.set(song, misses);
			FlxG.save.data.songMisses = songMisses;
			FlxG.save.flush();
		}

		static function setBreaks(song:String, breaks:Int):Void
			{
				// Reminder that I don't need to format this song, it should come formatted!
				songBreaks.set(song, breaks);
				FlxG.save.data.songBreaks = songBreaks;
				FlxG.save.flush();
			}

		static function setHits(song:String, hits:Int):Void
			{
				// Reminder that I don't need to format this song, it should come formatted!
				songGoodHits.set(song, hits);
				FlxG.save.data.songGoodHits = songGoodHits;
				FlxG.save.flush();
			}

		static function setRating(song:String, rating:Int):Void
			{
				// Reminder that I don't need to format this song, it should come formatted!
				songRating.set(song, rating);
				FlxG.save.data.songRating = songRating;
				FlxG.save.flush();
			}

	public static function formatSong(song:String, diff:Int):String
	{
		var daSong:String = song;

		if (diff == 0)
			daSong += '-easy';
		else if (diff == 2)
			daSong += '-hard';

		return daSong;
	}

	public static function getScore(song:String, diff:Int):Int
	{
		if (!songScores.exists(formatSong(song, diff)))
			setScore(formatSong(song, diff), 0);

		return songScores.get(formatSong(song, diff));
	}

	public static function getMisses(song:String, diff:Int):Int
		{
			if (!songMisses.exists(formatSong(song, diff)))
				setMiss(formatSong(song, diff), 0);
	
			return songMisses.get(formatSong(song, diff));
		}

		public static function getBreaks(song:String, diff:Int):Int
			{
				if (!songBreaks.exists(formatSong(song, diff)))
					setBreaks(formatSong(song, diff), 0);
		
				return songBreaks.get(formatSong(song, diff));
			}

		public static function getHits(song:String, diff:Int):Int
			{
				if (!songGoodHits.exists(formatSong(song, diff)))
					setHits(formatSong(song, diff), 0);
		
				return songGoodHits.get(formatSong(song, diff));
			}

		public static function getRating(song:String, diff:Int):Int
			{
				if (!songRating.exists(formatSong(song, diff)))
					setRating(formatSong(song, diff), 0);
		
				return songRating.get(formatSong(song, diff));
			}

	public static function getWeekScore(week:Int, diff:Int):Int
	{
		if (!songScores.exists(formatSong('week' + week, diff)))
			setScore(formatSong('week' + week, diff), 0);

		return songScores.get(formatSong('week' + week, diff));
	}

	public static function load():Void
	{
		if (FlxG.save.data.songScores != null)
		{
			songScores = FlxG.save.data.songScores;
		}

			if (FlxG.save.data.songMisses != null)
				{
					songMisses = FlxG.save.data.songMisses;
				}

				if (FlxG.save.data.songBreaks != null)
					{
						songBreaks = FlxG.save.data.songBreaks;
					}

				if (FlxG.save.data.songRating != null)
					{
						songRating = FlxG.save.data.songRating;
					}

					if (FlxG.save.data.songGoodHits != null)
						{
							songGoodHits = FlxG.save.data.songGoodHits;
						}
	}
}
