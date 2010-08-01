
#include <sys/time.h>
#import "CountdownViewController.h"

double milliseconds()
{
	struct timeval tv;
	gettimeofday(&tv, NULL);
	return tv.tv_sec * 1000.0 + tv.tv_usec / 1000.0;
}

@interface CountdownViewController ()
- (void)initGame;
- (void)toGameWaiting;
- (void)toGameWaitingPlayer1;
- (void)toGameWaitingPlayer2;
- (void)toGameStarting;
- (void)toGamePlaying;
- (void)endGame;
- (void)updateScores;
- (void)updateClocks;
- (void)startTimer;
- (void)stopTimer;
@end

@implementation CountdownViewController

@synthesize player1Button;
@synthesize player2Button;
@synthesize clock1Label;
@synthesize clock2Label;
@synthesize player1Label;
@synthesize player2Label;
@synthesize player1ScoreLabel;
@synthesize player2ScoreLabel;

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
	{		
		timer = nil;
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	redColor = [[UIColor alloc] initWithRed:0.5f green:0.0f blue:0.0f alpha:1.0f];

	player2Button.transform     = CGAffineTransformMakeScale(-1.0, -1.0);
	clock2Label.transform       = CGAffineTransformMakeScale(-1.0, -1.0);
	player2Label.transform      = CGAffineTransformMakeScale(-1.0, -1.0);
	player2ScoreLabel.transform = CGAffineTransformMakeScale(-1.0, -1.0);

	[self initGame];
	[self startTimer];
}

/*
 * Called the very first time only.
 */
- (void)initGame
{
	srand(time(NULL));

	player1Score = 0;
	player2Score = 0;

	[self toGameWaiting];
}

/*
 * Moves from the initial state or state STARTING, to state WAITING.
 */
- (void)toGameWaiting
{
	gameState = GAME_WAITING;
	player1State = PLAYER_WAITING;
	player2State = PLAYER_WAITING;

	clock1Label.text = @"Countdown";
	clock2Label.text = @"Ultimate";
	clock1Label.textColor = [UIColor blackColor];
	clock2Label.textColor = [UIColor blackColor];
	player1Label.text = @"Press the button to start";
	player2Label.text = @"Press the button to start";

	[self updateScores];
}

/*
 * Moves from the initial state or state STARTING, to state WAITING.
 * Only resets the state for player 1.
 */
- (void)toGameWaitingPlayer1
{
	gameState = GAME_WAITING;
	player1State = PLAYER_WAITING;

	clock1Label.text = @"Countdown";
	clock2Label.text = @"Ultimate";
	clock1Label.textColor = [UIColor blackColor];
	clock2Label.textColor = [UIColor blackColor];
	player1Label.text = @"Press the button to start";
	player2Label.text = @"Waiting for the other player...";

	[self updateScores];
}

/*
 * Moves from the initial state or state STARTING, to state WAITING.
 * Only resets the state for player 2.
 */
- (void)toGameWaitingPlayer2
{
	gameState = GAME_WAITING;
	player2State = PLAYER_WAITING;

	clock1Label.text = @"Countdown";
	clock2Label.text = @"Ultimate";
	clock1Label.textColor = [UIColor blackColor];
	clock2Label.textColor = [UIColor blackColor];
	player1Label.text = @"Waiting for the other player...";
	player2Label.text = @"Press the button to start";

	[self updateScores];
}

/*
 * Moves from state WAITING to state STARTING.
 */
- (void)toGameStarting
{
	gameState = GAME_STARTING;
	startTime = milliseconds();

	clock1Label.text = @"1000";
	clock2Label.text = @"1000";
	clock1Label.textColor = [UIColor blackColor];
	clock2Label.textColor = [UIColor blackColor];
	player1Label.text = @"Get ready...";
	player2Label.text = @"Get ready...";
}

/*
 * Moves from state STARTING to state PLAYING.
 */
- (void)toGamePlaying
{
	speed    = 0.9;         // 0.1 * (rand() % 20);
	maxCount = 1000;        // 500 + (rand() % 10) * 100;
	minCount = -maxCount;
	count    = maxCount;

	player1Count = maxCount;
	player2Count = maxCount;

	gameState = GAME_PLAYING;
	startTime = milliseconds();

	[self updateClocks];
	player1Label.text = @"";
	player2Label.text = @"";
}

/*
 * Moves from state PLAYING to state WAITING.
 */
- (void)endGame
{
	if (gameState == GAME_PLAYING)
	{
		[self updateClocks];

		// You lose when your count is less than 0, or when the other
		// player has lower count than you. However, if your count is more
		// than 0 and the other player goes below 0, then you win.

		BOOL player1Lost = (player1Count < 0) 
			|| (player2Count < player1Count && player2Count >= 0);

		BOOL player2Lost = (player2Count < 0) 
			|| (player1Count < player2Count && player1Count >= 0);

		if (player1Lost && player2Lost)
		{
			player1Label.text = @"Both players lose";
			player2Label.text = @"Both players lose";
		}
		else if (!player1Lost && !player2Lost)
		{
			player1Label.text = @"It's a tie!";
			player2Label.text = @"It's a tie!";
		}
		else if (player1Lost)
		{
			player1Label.text = @"You lose";
			player2Label.text = @"You win!";
			++player2Score;
		}
		else
		{
			player1Label.text = @"You win!";
			player2Label.text = @"You lose";
			++player1Score;
		}
	}

	gameState = GAME_WAITING;
	player1State = PLAYER_WAITING;
	player2State = PLAYER_WAITING;
	[self updateScores];
}

- (IBAction)player1ButtonDown
{
	if (gameState == GAME_WAITING)
	{
		player1State = PLAYER_PRESSED;
		if (player2State == PLAYER_PRESSED)
		{
			[self toGameStarting];
		}
		else
		{
			player1Label.text = @"Waiting for the other player...";
			player2Label.text = @"Press the button to join the game";
			clock1Label.text = @"Countdown";
			clock2Label.text = @"Ultimate";
			clock1Label.textColor = [UIColor blackColor];
			clock2Label.textColor = [UIColor blackColor];
		}
	}
}

- (IBAction)player2ButtonDown
{
	if (gameState == GAME_WAITING)
	{
		player2State = PLAYER_PRESSED;
		if (player1State == PLAYER_PRESSED)
		{
			[self toGameStarting];
		}
		else
		{
			player1Label.text = @"Press the button to join the game";
			player2Label.text = @"Waiting for the other player...";
			clock1Label.text = @"Countdown";
			clock2Label.text = @"Ultimate";
			clock1Label.textColor = [UIColor blackColor];
			clock2Label.textColor = [UIColor blackColor];
		}
	}
}

- (IBAction)player1ButtonUp
{
	if (gameState == GAME_PLAYING)
	{
		if (player1State == PLAYER_PRESSED)
		{
			player1State = PLAYER_RELEASED;
			player1Count = count;
			if (player2State == PLAYER_RELEASED)
				[self endGame];
		}
	}
	else if (gameState == GAME_STARTING || gameState == GAME_WAITING)
	{
		if (player2State == PLAYER_WAITING)
			[self toGameWaiting];
		else
			[self toGameWaitingPlayer1];
	}
}

- (IBAction)player2ButtonUp
{
	if (gameState == GAME_PLAYING)
	{
		if (player2State == PLAYER_PRESSED)
		{
			player2State = PLAYER_RELEASED;
			player2Count = count;
			if (player1State == PLAYER_RELEASED)
				[self endGame];
		}
	}
	else if (gameState == GAME_STARTING || gameState == GAME_WAITING)
	{
		if (player1State == PLAYER_WAITING)
			[self toGameWaiting];
		else
			[self toGameWaitingPlayer2];
	}
}

/*
 * Redraws the scoreboards.
 */
- (void)updateScores
{
	player1ScoreLabel.text = [NSString stringWithFormat:@"%d", player1Score];
	player2ScoreLabel.text = [NSString stringWithFormat:@"%d", player2Score];
}

/*
 * Draws the counters in the clock labels.
 */
- (void)updateClocks
{
	int clockCount;

	if (player1State == PLAYER_RELEASED)
		clockCount = player1Count;
	else
		clockCount = count;
	
	clock1Label.text = [NSString stringWithFormat:@"%d", clockCount];
	if (clockCount < 0)
		clock1Label.textColor = redColor;

	if (player2State == PLAYER_RELEASED)
		clockCount = player2Count;
	else
		clockCount = count;

	clock2Label.text = [NSString stringWithFormat:@"%d", clockCount];
	if (clockCount < 0)
		clock2Label.textColor = redColor;
}

/*
 * Starts the timer loop.
 */
- (void)startTimer
{
	timer = [NSTimer scheduledTimerWithTimeInterval: 0.04  // 40 ms
											 target: self
										   selector: @selector(handleTimer:)
										   userInfo: nil
											repeats: YES];
}

/*
 * Kills the timer loop.
 */
- (void)stopTimer
{
	if (timer != nil && [timer isValid])
	{
		[timer invalidate];
		timer = nil;
	}
}

/*
 * The timer loop.
 */
- (void)handleTimer:(NSTimer*)timer
{
	double now = milliseconds();

	if (gameState == GAME_STARTING)
	{
		if (now - startTime > 500)   // wait a little before 
			[self toGamePlaying];    // countdown starts
	}
	else if (gameState == GAME_PLAYING)
	{
		count = maxCount - (now - startTime)*speed;
		if (count <= minCount)
		{
			count = minCount;
			
			if (player1State == PLAYER_PRESSED)
			{
				player1State = PLAYER_RELEASED;
				player1Count = minCount;
			}
			
			if (player2State == PLAYER_PRESSED)
			{
				player2State = PLAYER_RELEASED;
				player2Count = minCount;
			}
			
			[self endGame];
		}
		else
		{
			[self updateClocks];
		}
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)dealloc
{
	[self stopTimer];
	[player1Button release];
	[player2Button release];
	[clock1Label release];
	[clock2Label release];
	[player1Label release];
	[player2Label release];
	[player1ScoreLabel release];
	[player2ScoreLabel release];
	[redColor release];
	[super dealloc];
}

@end
