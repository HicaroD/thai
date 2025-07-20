<script lang="ts">
  import { goto } from "$app/navigation";
  import {
    Card,
    CardDescription,
    CardHeader,
    CardTitle,
  } from "$lib/features/shared/components/_shadcn/ui/card";
  import { Timer, Palette } from "@lucide/svelte";
</script>

<div class="grid gap-6 max-w-md mx-auto">
  <Card
    class="bg-gray-900 border-gray-700 hover:border-yellow-400 transition-colors cursor-pointer"
    onclick={() => goto("/timer-sequence")}
  >
    <CardHeader class="text-center">
      <div
        class="w-16 h-16 thai-bg-gradient rounded-full flex items-center justify-center mx-auto mb-4"
      >
        <Timer class="w-8 h-8 text-black" />
      </div>
      <CardTitle class="text-white text-xl">Timers Sequenciais</CardTitle>
      <CardDescription class="text-gray-400">
        Configure uma série de timers com intervalos para seus treinos
      </CardDescription>
    </CardHeader>
  </Card>

  <Card
    class="bg-gray-900 border-gray-700 hover:border-yellow-400 transition-colors cursor-pointer"
    onclick={() => goto("/colors")}
  >
    <CardHeader class="text-center">
      <div
        class="w-16 h-16 thai-bg-gradient rounded-full flex items-center justify-center mx-auto mb-4"
      >
        <Palette class="w-8 h-8 text-black" />
      </div>
      <CardTitle class="text-white text-xl">Treino de Cores</CardTitle>
      <CardDescription class="text-gray-400">
        Treine com cores aleatórias para melhorar seus reflexos
      </CardDescription>
    </CardHeader>
  </Card>
</div>
