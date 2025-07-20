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
  import { Checkbox } from "$lib/features/shared/components/_shadcn/ui/checkbox";
  import { Play, Pause, Square, Settings } from "@lucide/svelte";

  type Color = {
    name: string;
    value: string;
    bg: string;
    text: string;
  };

  const availableColors: Color[] = [
    { name: "Vermelho", value: "red", bg: "bg-red-500", text: "text-white" },
    { name: "Azul", value: "blue", bg: "bg-blue-500", text: "text-white" },
    { name: "Verde", value: "green", bg: "bg-green-500", text: "text-white" },
    {
      name: "Amarelo",
      value: "yellow",
      bg: "bg-yellow-400",
      text: "text-black",
    },
    { name: "Roxo", value: "purple", bg: "bg-purple-500", text: "text-white" },
    {
      name: "Laranja",
      value: "orange",
      bg: "bg-orange-500",
      text: "text-white",
    },
  ];

  let selectedColors = $state(["red", "blue", "green", "yellow"]);
  let displayTime = $state(3);
  let totalTime = $state(60);
  let showSettings = $state(true);

  let isRunning = $state(false);
  let currentColor = $state<Color | null>(null);
  let timeLeft = $state(0);
  let sessionTimeLeft = $state(0);
  let intervalId = $state<number | null>(null);

  function toggleColor(color: string) {
    if (selectedColors.includes(color)) {
      selectedColors = selectedColors.filter((c) => c !== color);
    } else {
      selectedColors = [...selectedColors, color];
    }
  }

  function getRandomColor() {
    if (selectedColors.length === 0) return null;
    const randomIndex = Math.floor(Math.random() * selectedColors.length);
    return (
      availableColors.find((c) => c.value === selectedColors[randomIndex]) ??
      null
    );
  }

  function startTraining() {
    if (selectedColors.length === 0) return;

    isRunning = true;
    showSettings = false;
    sessionTimeLeft = totalTime;
    showNewColor();

    intervalId = setInterval(() => {
      sessionTimeLeft--;
      timeLeft--;

      if (timeLeft <= 0) {
        showNewColor();
      }

      if (sessionTimeLeft <= 0) {
        stopTraining();
      }
    }, 1000);
  }

  function showNewColor() {
    currentColor = getRandomColor();
    timeLeft = displayTime;
  }

  function pauseTraining() {
    isRunning = false;
    if (intervalId) {
      clearInterval(intervalId);
      intervalId = null;
    }
  }

  function stopTraining() {
    isRunning = false;
    showSettings = true;
    currentColor = null;
    timeLeft = 0;
    sessionTimeLeft = 0;
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

<svelte:head>
  <title>Treino de cores</title>
</svelte:head>

<div class="space-y-6">
  {#if isRunning && currentColor}
    <div
      class="fixed inset-0 z-50 flex items-center justify-center {currentColor.bg}"
    >
      <div class="text-center">
        <div class="text-8xl font-bold {currentColor.text} mb-8">
          {currentColor.name.toUpperCase()}
        </div>
        <div class="text-4xl font-mono {currentColor.text} mb-4">
          {timeLeft}
        </div>
        <div class="text-xl {currentColor.text} opacity-75">
          Sessão: {formatTime(sessionTimeLeft)}
        </div>
        <div class="mt-8">
          <Button onclick={pauseTraining} variant="secondary" class="mr-4">
            <Pause class="w-4 h-4 mr-2" />
            Pausar
          </Button>
          <Button onclick={stopTraining} variant="destructive">
            <Square class="w-4 h-4 mr-2" />
            Parar
          </Button>
        </div>
      </div>
    </div>
  {/if}

  {#if showSettings}
    <Card class="bg-gray-900 border-gray-700">
      <CardHeader>
        <CardTitle class="text-white flex items-center">
          <Settings class="w-5 h-5 mr-2" />
          Configurações do Treino
        </CardTitle>
      </CardHeader>
      <CardContent class="space-y-6">
        <div>
          <Label class="text-white text-base mb-4 block"
            >Cores Disponíveis</Label
          >
          <div class="grid grid-cols-2 gap-3">
            {#each availableColors as color}
              <div class="flex items-center space-x-3">
                <Checkbox
                  id={color.value}
                  checked={selectedColors.includes(color.value)}
                  onCheckedChange={() => toggleColor(color.value)}
                  class="data-[state=checked]:bg-blue-600 data-[state=unchecked]:bg-gray-800"
                />
                <label
                  for={color.value}
                  class="flex items-center cursor-pointer"
                >
                  <div class="w-6 h-6 rounded {color.bg} mr-2"></div>
                  <span class="text-white">{color.name}</span>
                </label>
              </div>
            {/each}
          </div>
        </div>

        <div class="grid grid-cols-2 gap-4">
          <div>
            <Label for="display-time" class="text-white pb-4"
              >Tempo por Cor (segundos)</Label
            >
            <Input
              id="display-time"
              type="number"
              bind:value={displayTime}
              min="1"
              max="10"
              class="bg-gray-800 border-gray-600 text-white"
            />
          </div>
          <div>
            <Label for="total-time" class="text-white pb-4"
              >Duração Total (segundos)</Label
            >
            <Input
              id="total-time"
              type="number"
              bind:value={totalTime}
              min="10"
              class="bg-gray-800 border-gray-600 text-white"
            />
          </div>
        </div>

        <!-- Start Button -->
        <Button
          onclick={startTraining}
          disabled={selectedColors.length === 0}
          class="w-full bg-green-600 hover:bg-green-700 text-white text-lg py-3"
        >
          <Play class="w-5 h-5 mr-2" />
          Iniciar Treino de Cores
        </Button>

        {#if selectedColors.length === 0}
          <p class="text-red-400 text-sm text-center">
            Selecione pelo menos uma cor para começar
          </p>
        {/if}
      </CardContent>
    </Card>

    <!-- Preview -->
    <Card class="bg-gray-900 border-gray-700">
      <CardHeader>
        <CardTitle class="text-white">Preview das Cores</CardTitle>
      </CardHeader>
      <CardContent>
        <div class="grid grid-cols-2 gap-3">
          {#each availableColors.filter( (c) => selectedColors.includes(c.value), ) as color}
            <div class="p-4 rounded-lg {color.bg} text-center">
              <span class="font-bold {color.text}">{color.name}</span>
            </div>
          {/each}
        </div>
      </CardContent>
    </Card>
  {/if}

  <!-- Status when paused -->
  {#if isRunning && !currentColor}
    <Card class="bg-gray-900 border-gray-700">
      <CardContent class="p-8 text-center">
        <div class="text-2xl font-bold text-white mb-4">Treino Pausado</div>
        <div class="text-lg text-gray-400 mb-6">
          Tempo restante: {formatTime(sessionTimeLeft)}
        </div>
        <div class="flex justify-center gap-4">
          <Button
            onclick={startTraining}
            class="bg-green-600 hover:bg-green-700"
          >
            <Play class="w-4 h-4 mr-2" />
            Continuar
          </Button>
          <Button onclick={stopTraining} variant="destructive">
            <Square class="w-4 h-4 mr-2" />
            Parar
          </Button>
        </div>
      </CardContent>
    </Card>
  {/if}
</div>
