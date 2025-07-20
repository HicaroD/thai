<script lang="ts">
  import { Button } from "$lib/features/shared/components/_shadcn/ui/button";
  import {
    Card,
    CardContent,
    CardHeader,
    CardTitle,
  } from "$lib/features/shared/components/_shadcn/ui/card";
  import { Input } from "$lib/features/shared/components/_shadcn/ui/input";
  import { Label } from "$lib/features/shared/components/_shadcn/ui/label";
  import { Play, Pause, Square, Plus, Trash2 } from "@lucide/svelte";

  type Timer = {
    name: string;
    duration: number;
    interval: number;
  };

  let timers: Timer[] = $state([
    { name: "Aquecimento", duration: 60, interval: 10 },
    { name: "Round 1", duration: 180, interval: 60 },
    { name: "Round 2", duration: 180, interval: 60 },
  ]);

  let currentTimerIndex = $state(0);
  let timeLeft = $state(0);
  let intervalTimeLeft = $state(0);
  let isRunning = $state(false);
  let isInterval = $state(false);
  let intervalId = $state<number | null>(null);

  let newTimer = $state({ name: "", duration: 60, interval: 30 });

  function addTimer() {
    if (newTimer.name.trim()) {
      timers.push({ ...newTimer });
      newTimer = { name: "", duration: 60, interval: 30 };
    }
  }

  function removeTimer(index: number) {
    timers.splice(index, 1);
  }

  function startTimer() {
    if (!isRunning && timers.length > 0) {
      isRunning = true;
      if (timeLeft === 0) {
        timeLeft = timers[currentTimerIndex].duration;
      }

      intervalId = setInterval(() => {
        if (isInterval) {
          intervalTimeLeft--;
          if (intervalTimeLeft <= 0) {
            isInterval = false;
            currentTimerIndex++;
            if (currentTimerIndex >= timers.length) {
              stopTimer();
              return;
            }
            timeLeft = timers[currentTimerIndex].duration;
          }
        } else {
          timeLeft--;
          if (timeLeft <= 0) {
            if (currentTimerIndex < timers.length - 1) {
              isInterval = true;
              intervalTimeLeft = timers[currentTimerIndex].interval;
            } else {
              stopTimer();
            }
          }
        }
      }, 1000);
    }
  }

  function pauseTimer() {
    isRunning = false;
    if (intervalId) {
      clearInterval(intervalId);
      intervalId = null;
    }
  }

  function stopTimer() {
    isRunning = false;
    isInterval = false;
    currentTimerIndex = 0;
    timeLeft = 0;
    intervalTimeLeft = 0;
    if (intervalId) {
      clearInterval(intervalId);
      intervalId = null;
    }
  }

  function formatTime(seconds: number) {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins.toString().padStart(2, "0")}:${secs.toString().padStart(2, "0")}`;
  }
</script>

<div class="space-y-6">
  <Card class="bg-gray-900 border-gray-700">
    <CardContent class="p-8 text-center">
      {#if isRunning}
        <div class="mb-4">
          <h3 class="text-lg text-gray-400 mb-2">
            {isInterval
              ? "INTERVALO"
              : timers[currentTimerIndex]?.name || "Timer"}
          </h3>
          <div class="text-6xl font-mono font-bold text-white mb-4">
            {formatTime(isInterval ? intervalTimeLeft : timeLeft)}
          </div>
          <div class="text-sm text-gray-400">
            Timer {currentTimerIndex + 1} de {timers.length}
          </div>
        </div>
      {:else}
        <div class="text-4xl font-mono font-bold text-gray-500 mb-4">00:00</div>
        <div class="text-gray-400">Pronto para começar</div>
      {/if}

      <div class="flex justify-center gap-4 mt-6">
        {#if !isRunning}
          <Button
            onclick={startTimer}
            disabled={timers.length === 0}
            class="bg-green-600 hover:bg-green-700"
          >
            <Play class="w-4 h-4 mr-2" />
            Iniciar
          </Button>
        {:else}
          <Button
            onclick={pauseTimer}
            class="bg-yellow-600 hover:bg-yellow-700"
          >
            <Pause class="w-4 h-4 mr-2" />
            Pausar
          </Button>
        {/if}
        <Button onclick={stopTimer} variant="destructive">
          <Square class="w-4 h-4 mr-2" />
          Parar
        </Button>
      </div>
    </CardContent>
  </Card>

  <Card class="bg-gray-900 border-gray-700">
    <CardHeader>
      <CardTitle class="text-white">Sequência de Timers</CardTitle>
    </CardHeader>
    <CardContent class="space-y-4">
      {#each timers as timer, index}
        <div
          class="flex items-center justify-between p-3 bg-gray-800 rounded-lg {currentTimerIndex ===
            index && isRunning
            ? 'ring-2 ring-yellow-400'
            : ''}"
        >
          <div>
            <div class="font-medium text-white">{timer.name}</div>
            <div class="text-sm text-gray-400">
              {formatTime(timer.duration)} + {formatTime(timer.interval)} intervalo
            </div>
          </div>
          <Button
            variant="ghost"
            size="icon"
            onclick={() => removeTimer(index)}
            class="text-red-400 hover:text-red-300"
          >
            <Trash2 class="w-4 h-4" />
          </Button>
        </div>
      {/each}
    </CardContent>
  </Card>

  <Card class="bg-gray-900 border-gray-700">
    <CardHeader>
      <CardTitle class="text-white">Adicionar Timer</CardTitle>
    </CardHeader>
    <CardContent class="space-y-4">
      <div>
        <Label for="timer-name" class="text-white pb-4">Nome do Timer</Label>
        <Input
          id="timer-name"
          bind:value={newTimer.name}
          placeholder="Ex: Round 1, Aquecimento..."
          class="bg-gray-800 border-gray-600 text-white"
        />
      </div>

      <div class="grid grid-cols-2 gap-4">
        <div>
          <Label for="duration" class="text-white pb-4">Duração (segundos)</Label>
          <Input
            id="duration"
            type="number"
            bind:value={newTimer.duration}
            min="1"
            class="bg-gray-800 border-gray-600 text-white"
          />
        </div>
        <div>
          <Label for="interval" class="text-white pb-4">Intervalo (segundos)</Label>
          <Input
            id="interval"
            type="number"
            bind:value={newTimer.interval}
            min="0"
            class="bg-gray-800 border-gray-600 text-white"
          />
        </div>
      </div>

      <Button
        onclick={addTimer}
        class="w-full bg-yellow-600 hover:bg-yellow-700 text-black"
      >
        <Plus class="w-4 h-4 mr-2" />
        Adicionar Timer
      </Button>
    </CardContent>
  </Card>
</div>
